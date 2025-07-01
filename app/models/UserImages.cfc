component extends=BaseModel accessors=true {
  property name='ui_uiid'      type='numeric'  sqltype='integer'    primary_key;
  property name='ui_usid'      type='numeric'  sqltype='integer';
  property name='ui_width'     type='numeric'  sqltype='integer'    default='0';
  property name='ui_height'    type='numeric'  sqltype='integer'    default='0';
  property name='ui_size'      type='numeric'  sqltype='integer';
  property name='ui_filename'  type='string'   sqltype='varchar';
  property name='ui_type'      type='string'   sqltype='varchar';
  property name='ui_dla'       type='date';
  property name='ui_rename'    type='string';
  property name='filefield'    type='string'                        default='ui_filename';

  belongs_to(class: 'Users',          key: 'ui_usid', relation: 'us_usid');
  has_many(class: 'BlogEntryImages',  key: 'ui_uiid', relation: 'bei_uiid');

  variables.image_longest_side = 1200; // ALL IMAGES WILL BE RESIZED BEFORE UPLOAD TO CDN
  variables.thumbnail_size = 256; // ALL IMAGES WILL BE RESIZED BEFORE UPLOAD TO CDN

  public string function dimensions() {
    return isNull(variables.ui_width) ? '' : '#variables.ui_width# x #variables.ui_height#';
  }

  public string function image_src() {
    return application.urls.cdn & remote_path() & image_name();
  }

  public string function image_src64() {
    return utility.imageToBase64(image_src());
  }

  public string function ratio() {
    return variables.ui_height==0 ? 0 : variables.ui_width / variables.ui_height;
  }

  public query function search(struct params) {
    if (arguments.keyExists('params')) arguments = arguments.params;
    if (!isNumeric(arguments.get('maxrows'))) arguments.maxrows = -1;

    var sproc = new StoredProc(procedure: 'userimages_search', datasource: datasource());
    sproc.addParam(cfsqltype: 'integer', value: arguments.get('ui_uiid'), null: !arguments.keyExists('ui_uiid'));
    sproc.addParam(cfsqltype: 'integer', value: arguments.get('ui_usid'), null: !arguments.keyExists('ui_usid'));
    sproc.addParam(cfsqltype: 'float',   value: arguments.get('ratio'),   null: !arguments.keyExists('ratio'));
    sproc.addParam(cfsqltype: 'varchar', value: arguments.get('term'),    null: !arguments.keyExists('term'));
    sproc.addProcResult(name: 'qry', resultset: 1, maxrows: arguments.maxrows);

    return paged_search(sproc, arguments);
  }

  public string function size_mb() {
    return isNull(variables.ui_size) ? 0 : numberFormat(variables.ui_size/1024/1024, '.0') & ' MB';
  }

  public string function thumbnail_src() {
    return application.urls.cdn & remote_path() & thumbnail_name();
  }

  public struct function thumbnail_update() {
    try {
      cffile(action: 'upload', filefield: 'thumbnail', destination: local_path() & thumbnail_name(), result: 'result', nameconflict: 'overwrite');
      utility.fileCopyS3(local_path() & thumbnail_name(), remote_src() & thumbnail_name());
      return result;
    } catch (any err) {
      return err;
    }
  }

  public array function uses() {
    if (new_record()) return [];

    if (isNull(variables._uses)) {
      var sproc = new StoredProc(procedure: 'userimages_uses', datasource: datasource());
      sproc.addParam(cfsqltype: 'varchar', value: utility.hashCC(ui_uiid));
      sproc.addProcResult(name: 'qry', resultset: 1);
      variables._uses = utility.query_to_array(sproc.execute().getProcResultSets().qry);
    }
    return variables._uses;
  }

  // PRIVATE

  private void function delete_image(required string filefield) {
    var field = find_field(arguments.filefield);
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
    return utility.hashCC(ui_uiid) & '.jpg';
  }

  private string function local_path() {
    return application.paths.images & 'user\'  & ui_usid % 10 & '\';
  }

  private any function make_thumbnail(required any img, numeric zoom=1.05) {
    var max = variables.thumbnail_size * arguments.zoom;
    var info = ImageInfo(img);
    if (info.height > info.width) {
      img.resize(max, '');
    } else if (info.width >= info.height) {
      img.resize('', max);
    }
    info = ImageInfo(img);
    var pos_x = (info.width - variables.thumbnail_size) / 2;
    var pos_y = (info.height - variables.thumbnail_size) / 2;
    img.crop(pos_x, pos_y, variables.thumbnail_size, variables.thumbnail_size);
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
    return application.urls.images & '/user/'  & ui_usid % 10 & '/';
  }

  private string function remote_src() {
    return application.s3.bucket & remote_path();
  }

  private void function post_destroy(required boolean success) {
    if (!success) return;
    delete_image('ui_filename');
  }

  private void function post_insert(required boolean success) {
    if (!success) return;
    upload_image();
  }

  private void function pre_save() {
    if (!isNull(variables.ui_rename)) variables.ui_filename = variables.ui_rename;
    if (this.filename_changed()) {
      variables.ui_filename = utility.slug(ui_filename);
    }
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
    return utility.hashCC(ui_uiid) & '_tn.jpg';
  }

  private void function upload_image() {
    try {
      if (variables.upload_result.fileWasSaved) {
        var filename = variables.upload_result.serverDirectory & '\' & variables.upload_result.serverfile;
        if (!directoryExists(local_path())) cfdirectory(action: 'create', directory: local_path(), mode: 644);
        variables.ui_filename = utility.slug(variables.ui_rename ?: variables.upload_result.clientfile);
        var info = move_final(filename);
        variables.ui_height = info.height;
        variables.ui_width = info.width;
        variables.ui_size = info.size;
        update_db();
      }
    } catch (any err) {
      errors().append(utility.errorString(err));
    }
  }
}
