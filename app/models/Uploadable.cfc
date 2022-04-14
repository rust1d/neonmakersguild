component extends=BaseModel accessors=true {
  // PROVIDES S3 UPLOAD CAPABILITY TO ANY FIELD WITH A BUCKET DEFINED
  // WILL AUTOMATICALLY SAVE THE FILE IN S3 BUCKET REPLACING EXISTING IF PRESENT
  // EACH FIELD WITH A BUCKET CAN HAVE A 'post_upload_#field.name#' METHOD TO VALIDATE
  // 'post_upload_#field.name#' CAN THROW AN ERROR TO HALT PROCESSING


  // PRIVATE

  private any function remote_src(required string fieldname) {
    var path = remote_public_path(fieldname);
    if (len(variables.get(fieldname))) return path & variables.get(fieldname);
  }

  private void function post_insert(required boolean success) {
    if (!success) return;

    process_uploads();
    if (changed()) update_db(); // SAVES THE FILENAMES AFTER UPLOAD
  }

  private void function pre_update() {
    process_uploads();
  }

  private void function process_uploads() {
    for (var field in GetMetaData(this).properties) {
      if (field.keyExists('bucket')) {
        variables.delete(field.name); // DELETE THE IMAGE VARIABLE SO IT DOESN'T OVERWRITE IF NOT CHANGED
        if (len(form.get(field.name))) process_upload(field);
      }
    }
  }

  private void function process_upload(required struct field) {
    var tmpDir = application.paths.physicalroot & 'tmp';
    cffile(action: 'upload', filefield: field.name, destination: tmpDir, result: 'result', nameconflict: 'overwrite');
    if (result.fileWasSaved) {
      var local_file = result.serverDirectory & '\' & result.serverfile;

       // CHECK FOR FILE VALIDATION METHOD -- THROW AN ERROR TO ABORT PROCESSING
      var post_upload = variables.get('post_upload_' & field.name);
      if (!isNull(post_upload)) post_upload(local_file);

      var remote_path = remote_private_path(field.name);
      var remote_file = result.serverfile.reReplace('[^0-9A-Za-z.]','_','All').listToArray('_').toList('_');
      var file_name = listFirst(remote_file,'.');
      var file_ext = listLast(remote_file,'.');
      file_name = file_name & '-' & table_prefix() & primary_key();
      var full_file = file_name & '.' & file_ext;
      FileCopy(local_file, remote_path & full_file);
      set_field(field, full_file);
      if (field_changed(field) && len(field_was(field))) { // NEW FILE, DELETE THE OLD ONE
        FileDelete(remote_path & field_was(field));
      }
      form.delete(field.name); // REMOVE FROM FORM SO WE DON'T REPROCESS
    } else {
      errors().append('Could not upload #result.clientFile#.');
    }
  }

  private string function remote_private_path(required string fieldname) {
    var field = find_field(fieldname);
    return application.s3.bucket & field.bucket;
  }

  private string function remote_public_path(required string fieldname) {
    var field = find_field(fieldname);
    return application.paths.cloudFrontDefault & field.bucket;
  }

  private any function image_resize(required any img, required numeric width, required numeric height) {
    var info = imageInfo(img);
    imageSetAntialiasing(img, 'on');
    if (info.height < info.width) {
      imageScaleTofit(img, '', height);
    } else {
      imageScaleTofit(img, width, '');
    }
    info = ImageInfo(img);
    img.crop((info.width-width)/2, (info.height-height)/2, width, height);
    cfimage(source: img, action: 'write', destination: img.source, overwrite: 'yes');
    return ImageRead(img.source);
  }

  private any function image_resize_and_square(required any img, required numeric size) {
    return image_resize(img, size, size);
  }

  private void function validate_image_size(required string filename, required numeric width, required numeric height) {
    // IMAGE MUST BE AT LEAST WIDTH X HEIGHT OR LARGER
    if (!isImageFile(filename)) throw 'Invalid image';
    var img = imageRead(filename);
    var info = imageInfo(img);
    if (info.width >= width && info.height >=height) {
      img = image_resize(img, width, height);
      info = imageInfo(img);
    }
    if (info.width != width || info.height != height) throw 'Invalid image size. Expected #width#x#height# and got #info.width#x#info.height#';
  }
}
