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

  belongs_to(class: 'Users',  key: 'ui_usid', relation: 'us_usid');

  variables.image_longest_side = 1200; // ALL IMAGES WILL BE RESIZED BEFORE UPLOAD TO CDN
  variables.thumbnail_size = 300; // ALL IMAGES WILL BE RESIZED BEFORE UPLOAD TO CDN

  public string function dimensions() {
    return isNull(variables.ui_width) ? '' : '#ui_width# x #ui_height#';
  }

  public string function image_src() {
    return remote_path() & image_name();
  }

  public string function image_src64() {
    return utility.imageToBase64(application.urls.root & image_src());
  }

  public string function ratio() {
    return variables.ui_height==0 ? 0 : ui_width / ui_height;
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
    return remote_path() & thumbnail_name();
  }

  public struct function thumbnail_update() {
    try {
      cffile(action: 'upload', filefield: 'thumbnail', destination: local_path() & thumbnail_name(), result: 'result', nameconflict: 'overwrite');
      return result;
    } catch (any err) {
      return err;
    }
  }

  public array function uses() {
    if (new_record()) return [];

    if (isNull(variables._uses)) {
      var sproc = new StoredProc(procedure: 'userimages_uses', datasource: datasource());
      sproc.addParam(cfsqltype: 'varchar', value: hash(ui_uiid));
      sproc.addProcResult(name: 'qry', resultset: 1);
      variables._uses = utility.query_to_array(sproc.execute().getProcResultSets().qry);
    }
    return variables._uses;
  }

  // PRIVATE

  private void function delete_image(required string filefield) {
    var field = find_field(filefield);
    if (field.isEmpty()) return;

    try {
      if (fileExists(local_path() & image_name())) fileDelete(local_path() & image_name());
      if (fileExists(local_path() & thumbnail_name())) fileDelete(local_path() & thumbnail_name());
      return;
    } catch (any err) { }
    errors().append('Could not delete #image_name()#.');
  }

  private string function image_name() {
    return hash(ui_uiid) & '.jpg' //& ui_filename.listLast('.');
  }

  private string function thumbnail_name() {
    return hash(ui_uiid) & '_tn.jpg' //& ui_filename.listLast('.');
  }

  private string function local_path() {
    return application.paths.images & 'user\'  & ui_usid % 10 & '\';
  }

  private string function remote_path() {
    return application.urls.images & '/user/'  & ui_usid % 10 & '/';
  }

  private void function post_destroy(required boolean success) {
    if (!success) return;
    if (uses().isEmpty()) delete_image('ui_filename');
  }

  private void function post_insert(required boolean success) {
    if (!success) return;
    if (upload_image()) {
      update_db(); // DIRECTLY CALL UPDATE TO AVOID CALLBACKS
    } else {
      delete_db(); // REMOVE THE RECORD IF IMAGE FAILS
    }
  }

  private void function pre_save() {
    if (!isNull(variables.ui_rename)) variables.ui_filename = variables.ui_rename;
    if (this.filename_changed()) {
      variables.ui_filename = utility.slug(ui_filename);
    }
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
    var img = ImageRead(filename);
    var orientation = ImageGetEXIFTag(img, 'orientation');

    var info = ImageInfo(img);
    if (info.height > image_longest_side || info.width > image_longest_side) { // ENFORCE MAX DIMENSION
      img.scaleTofit(image_longest_side, image_longest_side);
      info = ImageInfo(img);
    }

    cfimage(action: 'write', source: img, destination: local_path() & image_name(), quality: 1, overwrite: 'true');
    info.append(GetFileInfo(local_path() & image_name()));
    img = make_thumbnail(img);
    cfimage(action: 'write', source: img, destination: local_path() & thumbnail_name(), quality: 1, overwrite: 'true');

    return info;
  }

  private boolean function upload_image() {
    var filefield = 'ui_filename';
    if (len(form.get(filefield))==0) return false; // NO FILE
    cffile(action: 'upload', filefield: filefield, destination: application.paths.root & 'tmp', result: 'result', nameconflict: 'overwrite');
    if (result.fileWasSaved) {
      var filename = result.serverDirectory & '\' & result.serverfile;
      if (isImageFile(filename)) {
        if (!directoryExists(local_path())) directoryCreate(local_path());
        variables.ui_filename = utility.slug(variables.ui_rename ?: result.clientfile);
        var info = move_final(filename);
        variables.ui_height = info.height;
        variables.ui_width = info.width;
        variables.ui_size = info.size;
        return true;
      }
      errors().append('Uploaded Image is invalid.');
      return false;
    }
    errors().append('Could not upload #result.clientFile#.');
    return false;
  }
}
