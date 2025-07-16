// HANDLES DISPLAY / UPLOAD OF PROFILE PIC WHICH IS NOT STORED IN DB
component accessors=true {
  property name='usid'       type='numeric';
  property name='form_field' type='string'  default='profile_image';

  variables.thumb_size = 256;

  public ProfileImage function init(required numeric usid) {
    variables.usid = arguments.usid;
    variables.utility = application.utility;
    return this;
  }

  public void function destroy() {
    if (fileExists(path_to_file())) {
      FileDelete(path_to_file());
      utility.fileDeleteS3(remote_src());
    }
  }

  public boolean function exists() {
    return isImageFile(path_to_file());
  }

  public boolean function set() {
    if (!form.keyExists(form_field)) return false;
    return upload();
  }

  public ProfileImage function setId(required numeric usid) {
    variables.usid = arguments.usid;
    return this;
  }

  public string function src() {
    return exists() ? image_src() : placeholder_src();
  }

  public string function src64() {
    return exists() ? utility.imageToBase64(image_src()) : '';
  }

  // PRIVATE

  private void function ensure_folder() {
    if (!directoryExists(path_to_folder())) directoryCreate(path_to_folder());
  }

  private string function image_name() {
    return utility.hashCC(variables.usid) & '.jpg';
  }

  private string function image_src() {
    var ts = '';
    if (session.user.loggedIn() && session.user.usid()==usid) ts = '?#now().format('HHnnss')#';
    return application.urls.cdn & '/assets/images/profile/' & subfolder() & '/' & image_name() & ts;
  }

  private string function local_path() {
    return application.paths.root & 'assets\images\profile\' & subfolder() & '\';
  }

  private string function remote_path() {
    return application.urls.images & '/profile/' & subfolder() & '/';
  }

  private string function remote_src() {
    return application.s3.bucket & remote_path() & image_name();
  }

  private string function path_to_file() {
    return path_to_folder() & image_name();
  }

  private string function path_to_folder() {
    return application.paths.root & 'assets\images\profile\' & subfolder() & '\';
  }

  public string function placeholder_src() {
    return application.urls.cdn & '/assets/images/profile_placeholder.png';
  }

  private string function subfolder() {
    return variables.usid % 10;
  }

  private string function tmp_dir() {
    return application.paths.root & 'tmp';
  }

  private boolean function upload() {
    try {
      cffile(action: 'upload', filefield: form_field, destination: tmp_dir(), result: 'result', nameconflict: 'overwrite');
      if (result.fileWasSaved) {
        var path = result.serverDirectory & '\' & result.serverfile;
        if (!isImageFile(path)) {
          fileDelete(path);
          errors().append('File is not a valid image. Please pick another.');
          return false;
        }
        ensure_folder();
        var img = ImageRead(path);
        img.scaleTofit(variables.thumb_size, variables.thumb_size);
        cfimage(action: 'write', quality: .80, overwrite: 'true', source: img, destination: path);
        FileCopy(path, path_to_file());
        utility.fileCopyS3(path_to_file(), remote_src());
        return true;
      }
    } catch (any err) {
      application.flash.cferror(err);
    }
    return false;
  }
}
