component accessors=true {
  property name='_class'          type='string';
  property name='_pkid'           type='numeric';
  property name='_home'           type='string'   default='home/home';
  property name='_admin'          type='boolean'  default=false;
  property name='_loginattempts'  type='numeric'  default=0;
  property name='_view'           type='string'   default='grid';

  public CurrentUser function init() {
    return this;
  }

  public boolean function admin() {
    return loggedIn() && _admin==true;
  }

  public void function destroy(required string key) {
    variables.delete(key);
  }

  public struct function dump() {
    return isNull(variables._pkid) ? {} : { id: variables._pkid, class: variables._class }
  }

  public any function gets(required string key) {
    return has(key) ? variables[key] : javacast('null',0);
  }

  public boolean function has(required string key) {
    return variables.keyExists(key) ? true : false;
  }

  public boolean function loggedIn() {
    return !loggedOut();
  }

  public boolean function loggedOut() {
    return isNull(get_pkid());
  }

  public numeric function incLoginAttempt() {
    return ++variables._loginattempts;
  }

  public boolean function isA(required string typeof) {
    if (typeof=='admin') return admin();
    return loggedIn() && arguments.typeof == get_class();
  }

  public boolean function isNotA(required string typeof) {
    return !isA(arguments.typeof)
  }

  public BaseModel function model() {
    if (isNull(request._user_model)) {
      request._user_model = new 'app.models.#get_class()#'().find(get_pkid());
    }
    return request._user_model;
  }

  public any function onMissingMethod(required string missingMethodName, required struct missingMethodArguments) {
    return invoke(model(), missingMethodName, missingMethodArguments);
  }

  public void function requireLogin(required string typeof, boolean remember_location = true) {
    if (isA(typeof)) return security_check(); // CHECK IF PWD CHANGE OR MFA FLAG SET AND REDIRECT

    if (cgi.request_method=='get' && remember_location) {
      session.return_to = '#cgi.script_name#?#cgi.query_string#';
      application.flash.warning('Please login to continue.');
    } else {
      session.return_to = '';
    }
    session.site.set_site('nmg');
    request.router.redirect('login/login');
  }

  public void function security_check() {
    // if (model().passwordupdate_required()) {
    //   request.router.redirect(get_class() & '/security');
    // }
  }

  public void function set(required string key, required any val) {
    variables[key] = val;
  }

  public string function view(string data = '') {
    if (data.len()) variables._view = data;
    return _view;
  }
}
