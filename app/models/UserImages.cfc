component extends=BaseModel accessors=true {
  property name='ui_uiid'      type='numeric'  sqltype='integer'    primary_key;
  property name='ui_usid'      type='numeric'  sqltype='integer';
  property name='ui_width'     type='numeric'  sqltype='integer';
  property name='ui_height'    type='numeric'  sqltype='integer';
  property name='ui_size'      type='numeric'  sqltype='integer';
  property name='ui_filename'  type='string'   sqltype='varchar';
  property name='ui_type'      type='string'   sqltype='varchar';
  property name='ui_dla'       type='date';

  belongs_to(class: 'Users',  key: 'ui_usid', relation: 'us_usid');

  variables.image_longest_side = 1600; // ALL IMAGES WILL BE RESIZED BEFORE UPLOAD TO CDN
  variables.thumbnail_size = 300; // ALL IMAGES WILL BE RESIZED BEFORE UPLOAD TO CDN

  public query function search(struct params) {
    if (arguments.keyExists('params')) arguments = arguments.params;
    if (!isNumeric(arguments.get('maxrows'))) arguments.maxrows = -1;

    var sproc = new StoredProc(procedure: 'userimages_search', datasource: datasource());
    sproc.addParam(cfsqltype: 'integer', value: arguments.get('ui_uiid'), null: !arguments.keyExists('ui_uiid'));
    sproc.addParam(cfsqltype: 'integer', value: arguments.get('ui_usid'), null: !arguments.keyExists('ui_usid'));
    sproc.addProcResult(name: 'qry', resultset: 1, maxrows: arguments.maxrows);

    return sproc.execute().getProcResultSets().qry;
  }

  public string function image_src() {
    return remote_path() & '/' & image_name()
  }

  public string function image_src64() {
    return application.utility.imageToBase64(image_src());
  }

  public string function thumbnail_src() {
    return remote_path() & '/' & thumbnail_name()
  }

  // PRIVATE

  private void function delete_image(required string filefield) {
    var field = find_field(filefield);
    if (field.isEmpty()) return;

    try {
      fileDelete(local_path() & image_name());
      fileDelete(local_path() & thumbnail_name());
      return;
    } catch (any err) { }
    errors().append('Could not delete #image_name()#.');
  }

  private string function image_name() {
    return hash(ui_uiid) & '.' & ui_filename.listLast('.');
  }

  private string function thumbnail_name() {
    return hash(ui_uiid) & '_tn.' & ui_filename.listLast('.');
  }

  private string function local_path() {
    return application.paths.images & '\user\'  & ui_usid % 10 & '\';
  }

  private string function remote_path() {
    return application.urls.images & '/user/'  & ui_usid % 10 & '/';
  }

  private void function post_destroy(required boolean success) {
    if (!success) return;
    delete_image('ui_filename');
  }

  private void function post_insert(required boolean success) {
    if (!success) return;
    if (upload_image()) {
      update_db(); // DIRECTLY CALL UPDATE TO AVOID CALLBACKS
    } else {
      delete_db(); // REMOVE THE RECORD IF IMAGE FAILS
    }
  }

  private any function make_thumbnail(required any img) {
    var zoom = 1.25; // trim some edge from thumbnail
    var max = thumbnail_size * zoom;
    var info = ImageInfo(img);
    if (info.height > info.width) {
      img.resize(max, '');
    } else if (info.width > info.height) {
      img.resize('', max);
    }
    info = ImageInfo(img);
    var pos_x = (info.width - thumbnail_size) / 2;
    var pos_y = (info.height - thumbnail_size) / 2;
    img.crop(pos_x, pos_y, thumbnail_size, thumbnail_size);
    return img;
  }

  private boolean function upload_image() {
    var filefield = 'ui_filename';
    if (len(form.get(filefield))==0) return false; // NO FILE
    cffile(action: 'upload', filefield: filefield, destination: application.paths.root & 'tmp', result: 'result', nameconflict: 'overwrite');
    if (result.fileWasSaved) {
      var filename = result.serverDirectory & '\' & result.serverfile;
      if (isImageFile(filename)) {
        if (!directoryExists(local_path())) directoryCreate(local_path());
        variables.ui_filename = result.clientfile;
        var info = move_final(filename);
        variables.ui_height = info.height;
        variables.ui_width = info.width;
        variables.ui_size = result.filesize;
        return true;
      }
      errors().append('Uploaded Image is invalid.');
      return false;
    }
    errors().append('Could not upload #result.clientFile#.');
    return false;
  }

  private struct function move_final(required string filename) {
    var img = ImageRead(filename);
    var info = ImageInfo(img);
    if (info.height > image_longest_side || info.width > image_longest_side) { // ENFORCE MAX DIMENSION
      img.scaleTofit(image_longest_side, image_longest_side);
      info = ImageInfo(img);
    }
    cfimage(action: 'write', source: img, destination: local_path() & image_name());
    img = make_thumbnail(img);
    cfimage(action: 'write', source: img, destination: local_path() & thumbnail_name());

    return info;
  }
}
