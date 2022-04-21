// HANDLES DISPLAY / UPLOAD OF PROFILE PIC WHICH IS NOT STORED IN DB
component accessors=true {
  property name='usid'       type='numeric';
  property name='form_field' type='string'  default='profile_image';

  public ProfileImage function init(required numeric usid) {
    variables.usid = arguments.usid;
    return this;
  }

  public void function destroy() {
    if (fileExists(path_to_file())) FileDelete(path_to_file());
  }

  public boolean function exists() {
    return isImageFile(path_to_file());
  }

  public boolean function set() {
    if (!form.keyExists(form_field)) return false;
    return upload();
  }

  public string function src() {
    return exists() ? image_src() : placeholder_src();
  }

  public string function src64() {
    return exists() ? application.utility.imageToBase64(image_src()) : '';
  }

  // PRIVATE

  private void function ensure_folder() {
    if (!directoryExists(path_to_folder())) directoryCreate(path_to_folder());
  }

  private string function image_name() {
    return hash(variables.usid) & '.jpg';
  }

  private string function image_src() {
    var ts = '';
    if (session.user.loggedIn() && session.user.usid()==usid) ts = '?#now().format('HHnnss')#';
    return application.urls.root & '/assets/images/profile/' & subfolder() & '/' & image_name() & ts;
  }

  private string function path_to_file() {
    return path_to_folder() & image_name();
  }

  private string function path_to_folder() {
    return application.paths.root & 'assets\images\profile\' & subfolder() & '\';
  }

  public string function placeholder_src() {
    return application.urls.root & '/assets/images/profile_placeholder.png';
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
        ensure_folder();
        FileCopy(result.serverDirectory & '\' & result.serverfile, path_to_file());
        return true;
      }
    } catch (any err) {}
    return false;
  }
}
