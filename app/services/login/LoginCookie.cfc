component {
  public LoginCookie function init() {
    variables._cookie = 'nmgl';
    variables._multiplier = 104729;
    return this;
  }

  public void function create(required numeric pkid) {
    var num = arguments.pkid * variables._multiplier;
    var data = Encrypt(num, application.secrets.phrase, 'CFMX_COMPAT', 'Hex');
    cfcookie(name: variables._cookie, value: data, expires: 180, httponly: true, secure: true, samesite: 'strict');
  }

  public void function destroy() {
    cfcookie(name: variables._cookie, value: '', expires: 'now', httponly: true);
  }

  public boolean function login() {
    var mUser = login_with_cookie();
    if (mUser.persisted()) {
      session.user.set_pkid(mUser.usid());
      session.user.set_class('Users');
      session.user.set_home(mUser.seo_link());
      if (mUser.permissions() GT 0) session.user.set_admin('true');
    }
    return mUser.persisted();
  }

  // PRIVATE

  private numeric function decode(required string data) {
    var num = Decrypt(data, application.secrets.phrase, 'CFMX_COMPAT', 'Hex');
    return FLOOR(num / variables._multiplier);
  }

  private Users function login_with_cookie() {
    try {
      if (!cookie.keyExists(variables._cookie)) throw('no cookie');
      var pkid = decode(cookie[variables._cookie]);
      var mUser = new app.models.Users().find(pkid);
      if (IsDate(mUser.us_deleted())) throw('deleted user');
      return mUser;
    } catch (any err) {
      destroy();
      return new app.models.Users();
    }
  }
}
