component accessors=true {
  public void function login(required string user, required string password) {
    try {
      if (user.len()) {
        var qryUser = new app.models.Users().search(us_user: user);
        if (qryUser.len()==1) {
          if (application.bcrypt.checkpw(password, qryUser.us_password)) {
            sessionize_user(qryUser);
            redirect_to_site();
          }
        }
      }
    } catch (LoginFailure err) {
      application.flash.error(err.message);
      if (err.extendedInfo.len()) application.flash.error(err.extendedInfo);
    } catch (any err) {
      writedump(err);
      application.flash.error(utility.errorString(err));
    }
    application.flash.error('Login failure.');
  }

  // PRIVATE

  private void function sessionize_user(required query qryUser) {
    session.user.set_pkid(qryUser.us_usid);
    session.user.set_class('Users');
    session.user.set_home('user/home');
    session.user.set('view','grid');
    if (qryUser.us_permissions GT 0) session.user.set_admin('true');
  }

  private void function redirect_to_site() {
    var href = request.router.href(session.user.get_home());
    if (session.return_to.len()) {
      writedump(session.return_to);abort;
      href = session.return_to;
      session.return_to = '';
    }
    location(href, false);
  }
}
