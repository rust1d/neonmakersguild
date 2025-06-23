component extends=BaseModel accessors=true {
  property name='fi_fiid'      type='numeric'  sqltype='integer'    primary_key;
  property name='fi_foid'      type='numeric'  sqltype='integer';
  property name='fi_ftid'      type='numeric'  sqltype='integer';
  property name='fi_fmid'      type='numeric'  sqltype='integer';
  property name='fi_usid'      type='numeric'  sqltype='integer';
  property name='fi_width'     type='numeric'  sqltype='integer'    default='0';
  property name='fi_height'    type='numeric'  sqltype='integer'    default='0';
  property name='fi_size'      type='numeric'  sqltype='integer';
  property name='fi_filename'  type='string'   sqltype='varchar';
  property name='fi_added'     type='date';
  property name='filefield'    type='string'                        default='forum_image';

  belongs_to(name: 'Forum',        class: 'Forums',         key: 'fi_foid',  relation: 'fo_foid');
  belongs_to(name: 'ForumThread',  class: 'ForumThreads',   key: 'fi_ftid',  relation: 'ft_ftid');
  belongs_to(name: 'ForumMessage', class: 'ForumMessages',  key: 'fi_fmid',  relation: 'fm_fmid');
  belongs_to(name: 'User',         class: 'Users',          key: 'fi_usid',  relation: 'us_usid');

  variables.image_longest_side = 1000; // ALL IMAGES WILL BE RESIZED BEFORE UPLOAD TO CDN
  variables.thumbnail_size = 256;      // ALL IMAGES WILL BE RESIZED BEFORE UPLOAD TO CDN

  public string function dimensions() {
    return isNull(variables.fi_width) ? '' : '#variables.fi_width# x #variables.fi_height#';
  }

  public string function image_src() {
    return application.urls.cdn & remote_path() & image_name();
  }

  public string function image_src64() {
    return utility.imageToBase64(image_src());
  }

  public string function ratio() {
    return variables.fi_height==0 ? 0 : fi_width / fi_height;
  }

  public query function search(struct params) {
    if (arguments.keyExists('params')) arguments = arguments.params;
    if (!isNumeric(arguments.get('maxrows'))) arguments.maxrows = -1;

    var sproc = new StoredProc(procedure: 'forumimages_search', datasource: datasource());
    sproc.addParam(cfsqltype: 'integer', value: arguments.get('fi_fiid'), null: !arguments.keyExists('fi_fiid'));
    sproc.addParam(cfsqltype: 'integer', value: arguments.get('fi_foid'), null: !arguments.keyExists('fi_foid'));
    sproc.addParam(cfsqltype: 'integer', value: arguments.get('fi_ftid'), null: !arguments.keyExists('fi_ftid'));
    sproc.addParam(cfsqltype: 'integer', value: arguments.get('fi_fmid'), null: !arguments.keyExists('fi_fmid'));
    sproc.addParam(cfsqltype: 'integer', value: arguments.get('fi_usid'), null: !arguments.keyExists('fi_usid'));
    sproc.addProcResult(name: 'qry', resultset: 1, maxrows: arguments.maxrows);

    return paged_search(sproc, arguments);
  }

  public string function size_mb() {
    return isNull(variables.fi_size) ? 0 : numberFormat(variables.fi_size/1024/1024, '.0') & ' MB';
  }

  public string function thumbnail_src() {
    return application.urls.cdn & remote_path() & thumbnail_name();
  }

  // PRIVATE

  private void function delete_image(required string filefield) {
    var field = find_field(filefield);
    if (field.isEmpty()) return;

    try {
      if (fileExists(local_path() & image_name())) {
        fileDelete(local_path() & image_name());
        utility.fileDeleteS3(remote_src() & image_name());
      }
      if (fileExists(local_path() & thumbnail_name())) {
        fileDelete(local_path() & thumbnail_name());
        utility.fileDeleteS3(remote_src() & thumbnail_name());
      }
      return;
    } catch (any err) { }
    errors().append('Could not delete #image_name()#.');
  }

  private string function image_name() {
    return utility.hashCC(fi_fiid) & '.jpg';
  }

  private string function local_path() {
    return application.paths.images & 'forum\'  & fi_fmid % 10 & '\';
  }

  private any function make_thumbnail(required any img) {
    var zoom = 1.25; // trim some edge from thumbnail
    var max = thumbnail_size * zoom;
    var info = ImageInfo(img);
    if (info.height > info.width) {
      img.resize(max, '');
    } else if (info.width >= info.height) {
      img.resize('', max);
    }
    info = ImageInfo(img);
    var pos_x = (info.width - thumbnail_size) / 2;
    var pos_y = (info.height - thumbnail_size) / 2;
    img.crop(pos_x, pos_y, thumbnail_size, thumbnail_size);
    return img;
  }

  private struct function move_final(required string filename) {
    var img = utility.orient_image(ImageRead(filename));
    var info = ImageInfo(img);
    if (info.height > image_longest_side || info.width > image_longest_side) { // ENFORCE MAX DIMENSION
      img.scaleTofit(image_longest_side, image_longest_side);
      info = ImageInfo(img);
    }
    cfimage(action: 'write', source: img, destination: local_path() & image_name(), quality: 1, overwrite: 'true');
    info.append(GetFileInfo(local_path() & image_name()));
    img = make_thumbnail(img);
    cfimage(action: 'write', source: img, destination: local_path() & thumbnail_name(), quality: 1, overwrite: 'true');
    // COPY TO S3
    utility.fileCopyS3(local_path() & image_name(), remote_src() & image_name());
    utility.fileCopyS3(local_path() & thumbnail_name(), remote_src() & thumbnail_name());

    return info;
  }

  private string function remote_path() {
    return application.urls.images & '/forum/'  & fi_fmid % 10 & '/';
  }

  private string function remote_src() {
    return application.s3.bucket & remote_path();
  }

  private void function post_destroy(required boolean success) {
    if (!success) return;
    delete_image('fi_filename');
  }

  private void function post_insert(required boolean success) {
    if (!success) return;
    upload_image();
  }

  private void function pre_insert() {
    try {
      if (len(form.get(variables.filefield))==0) {
        errors().append('Image Missing');
        return;
      }

      var tmpDir = application.paths.root & 'tmp';
      setting requesttimeout=90 showdebugoutput='no'; // IMAGE PROCESSING TAKES EXTRA TIME
      cffile(action: 'upload', filefield: variables.filefield, destination: tmpDir, result: 'variables.upload_result', nameconflict: 'overwrite');
      if (!upload_result.fileWasSaved) {
        return errors().append('Could not upload #variables.upload_result.clientFile#.');
      }
      var local_file = upload_result.serverDirectory & '\' & upload_result.serverfile;
      if (!isImageFile(local_file)) {
        fileDelete(local_file);
        errors().append('File is not a valid image. Please pick another.');
      }
    } catch (any err) {
      errors().append(utility.errorString(err));
    }
  }

  private string function thumbnail_name() {
    return utility.hashCC(fi_fiid) & '_tn.jpg';
  }

  private void function upload_image() {
    try {
      if (variables.upload_result.fileWasSaved) {
        var filename = variables.upload_result.serverDirectory & '\' & variables.upload_result.serverfile;
        if (!directoryExists(local_path())) cfdirectory(action: 'create', directory: local_path(), mode: 644);
        variables.fi_filename = utility.slug(variables.fi_rename ?: variables.upload_result.clientfile);
        var info = move_final(filename);
        variables.fi_height = info.height;
        variables.fi_width = info.width;
        variables.fi_size = info.size;
        update_db();
      }
    } catch (any err) {
      errors().append(utility.errorString(err));
    }
  }
}
