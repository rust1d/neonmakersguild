component extends=BaseModel accessors=true {
  property name='sti_stiid'     type='numeric'  sqltype='integer'    primary_key;
  property name='sti_stid'      type='numeric'  sqltype='integer';
  property name='sti_width'     type='numeric'  sqltype='integer';
  property name='sti_height'    type='numeric'  sqltype='integer';
  property name='sti_size'      type='numeric'  sqltype='integer';
  property name='sti_filename'  type='string'   sqltype='varchar'    bucket='sage.cf-dist-01/student/images/';
  property name='sti_category'  type='string'   sqltype='varchar';
  property name='sti_add'       type='date';

  variables.image_longest_side = 1600; // ALL IMAGES WILL BE RESIZED BEFORE UPLOAD TO CDN
  variables.thumbnail_size = 300; // ALL IMAGES WILL BE RESIZED BEFORE UPLOAD TO CDN

  public query function search(struct params) {
    if (arguments.keyExists('params')) arguments = arguments.params;
    if (!isNumeric(arguments.get('maxrows'))) arguments.maxrows = -1;

    var sproc = new StoredProc(procedure: 'studentimages_search', datasource: datasource());
    sproc.addParam(cfsqltype: 'integer', value: arguments.get('sti_stiid'), null: !arguments.keyExists('sti_stiid'));
    sproc.addParam(cfsqltype: 'integer', value: arguments.get('sti_stid'),  null: !arguments.keyExists('sti_stid'));
    sproc.addProcResult(name: 'qry', resultset: 1, maxrows: arguments.maxrows);

    return sproc.execute().getProcResultSets().qry;
  }

  public string function image_src() {
    return application.cfs3.student_images & path_to_image();
  }

  public string function image_src64() {
    return application.utility.imageToBase64(image_src());
  }

  public string function thumbnail_src() {
    return application.cfs3.student_images & path_to_thumbnail();
  }

  // PRIVATE

  private void function delete_image(required string filefield) {
    var field = find_field(filefield);
    if (field.isEmpty()) return;
    if (isNull(field.get('bucket'))) return;
    var remote_path = application.s3.root & '@' & field.bucket;
    try {
      fileDelete(remote_path & path_to_image());
      fileDelete(remote_path & path_to_thumbnail());
      return;
    } catch (any err) { }
    errors().append('Could not delete #remote_file#.');
  }

  private string function path_to_image() {
    var sub = sti_stid % 10;
    var name = '/' & hash(sti_stiid) & '.';
    var ext = sti_filename.listLast('.');
    return sub & name & ext;
  }

  private string function path_to_thumbnail() {
    var sub = sti_stid % 10;
    var name = '/tn/' & hash(sti_stiid) & '.';
    var ext = sti_filename.listLast('.');
    return sub & name & ext;
  }

  private void function post_destroy(required boolean success) {
    if (!success) return;
    delete_image('sti_filename');
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
    // var img = ImageRead(filename);
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
    var filefield = 'sti_filename';
    if (len(form.get(filefield))==0) return false; // NO FILE
    var bucket = find_field(filefield).bucket;
    var temp_dir = application.paths.physicalroot & 'tmp';
    cffile(action: 'upload', filefield: filefield, destination: temp_dir, result: 'result', nameconflict: 'overwrite');
    if (result.fileWasSaved) {
      var filename = result.serverDirectory & '\' & result.serverfile;
      if (isImageFile(filename)) {
        variables.sti_filename = result.serverfile;
        var info = upload_s3(filename, bucket);
        variables.sti_height = info.height;
        variables.sti_width = info.width;
        variables.sti_size = result.filesize;
        return true;
      }
      errors().append('Uploaded Image is invalid.');
      return false;
    }
    errors().append('Could not upload #result.clientFile#.');
    return false;
  }

  private struct function upload_s3(required string filename, required string bucket) {
    var img = ImageRead(filename);
    var info = ImageInfo(img);
    if (info.height > image_longest_side || info.width > image_longest_side) { // ENFORCE MAX DIMENSION
      img.scaleTofit(image_longest_side, image_longest_side);
      info = ImageInfo(img);
    }
    var remote_path = application.s3.root & '@' & bucket;
    cfimage(action: 'write', source: img, destination: remote_path & path_to_image());

    img = make_thumbnail(img);
    cfimage(action: 'write', source: img, destination: remote_path & path_to_thumbnail());

    return info;
  }
}
