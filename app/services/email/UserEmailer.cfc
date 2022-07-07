component {
  public UserEmailer function init() {
    variables.router = request.router;
    variables.utility = application.utility;
    return this;
  }

  public void function SendLoginLink(required Users mUser) {
    var send_to = application.isDevelopment ? application.email.admin : mUser.email();
    var mMailer = new app.services.email.Emailer(
      to: send_to,
      testmode: true,
      subject: 'Your NeonMakersGuild.org Login',
      template: 'forgot_login.cfm',
      login_link: new app.services.user.AuthToken().magic_link(mUser),
      user: mUser.user()
    );

    mMailer.send();
  }

  public void function SendWelcome(required Users mUser, required string pwd) {
    var send_to = application.isDevelopment ? application.email.admin : mUser.email();
    var mMailer = new app.services.email.Emailer(
      to: send_to,
      testmode: true,
      subject: 'Welcome to the Neon Makers Guild!',
      template: 'user_welcome.cfm',
      temp_pwd: pwd,
      mUser: mUser
    );

    mMailer.send();
  }
}
