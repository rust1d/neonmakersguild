component accessors=true {
  public void function login(required string user, required string password, numeric pkid=0) {
    try {
      if (user.len()) {
        var mUsers = new app.models.Users().where(us_user: user);
        if (mUsers.len()==1) {
          var mUser = mUsers.first()
          if (pkid==mUser.usid() || application.bcrypt.checkpw(password, mUser.us_password())) {
            mUser.update_last_login();
            sessionize_user(mUser);
            redirect_to_site();
          }
        }
      }
    } catch (LoginFailure err) {
      application.flash.error(err.message);
      if (err.extendedInfo.len()) application.flash.error(err.extendedInfo);
    } catch (any err) {
      writedump(err);
      application.flash.cferror(err);
    }
    application.flash.error('Login failure.');
  }

  // PRIVATE

  private void function sessionize_user(required Users mUser) {
    session.user.set_pkid(mUser.usid());
    session.user.set_class('Users');
    session.user.set_home(mUser.seo_link());
    if (mUser.permissions() GT 0) session.user.set_admin('true');
  }

  private void function redirect_to_site() {
    var href = session.user.get_home(); // request.router.href(session.user.get_home());
    if (session.return_to.len()) {
      href = session.return_to;
      session.return_to = '';
    }
    location(href, false);
  }
}
