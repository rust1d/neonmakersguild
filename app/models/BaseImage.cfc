component extends=BaseModel accessors=true {
  variables.image_size = 1600;
  variables.thumb_size = 256;
  variables.image_root = 'site';

  public string function dimensions() {
    return _getval('width', '0') & ' x ' & _getval('height', '0');
  }

  public string function image_src() {
    return application.urls.cdn & remote_path() & image_name();
  }

  public string function image_src64() {
    return utility.imageToBase64(image_src());
  }

  public string function size_mb() {
    var size = _getval('size', 0) ?: 0;
    return numberFormat(size/1024/1024, '.0') & ' MB';
  }

  public numeric function size_image() {
    return variables.image_size;
  }

  public numeric function size_thumb() {
    return variables.thumb_size;
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

  // PRIVATE

  private any function _getval(required string suffix, any def) {
    var fld = find_field(table_prefix() & arguments.suffix);
    return get_field(fld) ?: arguments.def;
  }

  private any function _setval(required string suffix, any value) {
    var fld = find_field(table_prefix() & arguments.suffix);
    set_field(fld, arguments.value);
  }

  private void function delete_image() {
    try {
      if (fileExists(local_path() & image_name())) fileDelete(local_path() & image_name());
      if (fileExists(local_path() & thumbnail_name())) fileDelete(local_path() & thumbnail_name());
      utility.fileDeleteS3(remote_src() & image_name());
      utility.fileDeleteS3(remote_src() & thumbnail_name());
    } catch (any err) {
      errors().append('Could not delete #image_name()#.');
    }
  }

  private string function image_name() {
    return utility.hashCC(primary_key()) & '.jpg';
  }

  private string function local_path() {
    return application.paths.images & variables.image_root & '\'  & _getval('usid') % 10 & '\';
  }

  private any function make_thumbnail(required any img) {
    var info = ImageInfo(arguments.img);
    if (info.height > variables.thumb_size || info.width > variables.thumb_size) { // ENFORCE MAX DIMENSION
      arguments.img.scaleTofit(variables.thumb_size, variables.thumb_size);
    }
    return arguments.img;
  }

  private struct function move_final(required string filename) {
    var img = utility.orient_image(ImageRead(arguments.filename));
    var info = ImageInfo(img);
    if (info.height > variables.image_size || info.width > variables.image_size) { // ENFORCE MAX DIMENSION
      img.scaleTofit(variables.image_size, variables.image_size);
      info = ImageInfo(img);
    }
    var quality = utility.compression(info.height, info.width, variables.upload_result.filesize);
    cfimage(action: 'write', quality: quality, overwrite: 'true', source: img, destination: local_path() & image_name());
    cfimage(action: 'write', quality: quality, overwrite: 'true', source: make_thumbnail(img), destination: local_path() & thumbnail_name());
    utility.fileCopyS3(local_path() & image_name(), remote_src() & image_name());
    utility.fileCopyS3(local_path() & thumbnail_name(), remote_src() & thumbnail_name());
    info.append(GetFileInfo(local_path() & image_name()));
    return info;
  }

  private string function remote_path() {
    return application.urls.images & '/#variables.image_root#/'  & _getval('usid') % 10 & '/';
  }

  private string function remote_src() {
    return application.s3.bucket & remote_path();
  }

  private void function post_destroy(required boolean success) {
    if (!success) return;
    delete_image();
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

      if (isSimpleValue(form[variables.filefield])) { // XHR FORMDATA WILL HAVE ALREADY UPLOADED IMAGES
        var path = form[variables.filefield];
        if (!fileExists(path)) {
          return errors().append('Could not find upload #path#.');
        }
        variables.upload_result = { // MIMIC cffile RESULTS
          fileWasSaved:    true,
          clientFile:      getFileFromPath(path),
          serverFile:      getFileFromPath(path),
          serverDirectory: getDirectoryFromPath(path),
          fileSize:        GetFileInfo(path).size
        }
      } else {
        var tmpDir = application.paths.root & 'tmp';
        setting requesttimeout=90 showdebugoutput='no'; // IMAGE PROCESSING TAKES EXTRA TIME
        cffile(action: 'upload', filefield: variables.filefield, destination: tmpDir, result: 'variables.upload_result', nameconflict: 'overwrite');
        if (!upload_result.fileWasSaved) {
          return errors().append('Could not upload #variables.upload_result.clientFile#.');
        }
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

  private void function pre_save() {
    if (!isNull(variables.file_rename)) {
      _setval('filename', variables.file_rename);
    }
  }

  private string function thumbnail_name() {
    return utility.hashCC(primary_key()) & '_tn.jpg';
  }

  private void function upload_image() {
    try {
      if (variables.upload_result.fileWasSaved) {
        var filename = variables.upload_result.serverDirectory & '\' & variables.upload_result.serverfile;
        if (!directoryExists(local_path())) cfdirectory(action: 'create', directory: local_path(), mode: 644);
        _setval('filename', variables.file_rename ?: variables.upload_result.clientfile)
        var info = move_final(filename);
        _setval('height', info.height);
        _setval('width', info.width);
        _setval('size', info.size);
        update_db();
      }
    } catch (any err) {
      errors().append(utility.errorString(err));
    }
  }
}
