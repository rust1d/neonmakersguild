component accessors=true {
  public void function login(required string email, required string password) {
    try {
      if (application.utility.isEmail(email)) {
        var qryUser = new app.models.Users().search(us_email: email);
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
    session.user.set_class('User');
    session.user.set_home('user/home');
    if (qryUser.us_permissions GT 0) session.user.set_admin('true');
  }

  private void function redirect_to_site() {
    var href = request.router.href(session.user.get_home());
    if (session.return_to.len()) {
      href = session.return_to;
      session.return_to = '';
    }
    location(href, false);
  }
}