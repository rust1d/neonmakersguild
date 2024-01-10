component {
  public UserEmailer function init() {
    variables.router = request.router;
    variables.utility = application.utility;
    return this;
  }

  public void function SendLoginLink(required Users mUser) {
    var mMailer = new app.services.email.Emailer(
      to: mUser.email(),
      subject: 'Your NeonMakersGuild.org Login',
      template: 'forgot_login.cfm',
      login_link: new app.services.user.AuthToken().magic_link(mUser),
      user: mUser.user()
    );

    mMailer.send();
  }

  public void function SendRenewalReminder(required Users mUser) {
    var mMailer = new app.services.email.Emailer(
      to: mUser.email(),
      bcc: 'membership@neonmakersguild.org',
      subject: 'NeonMakersGuild.org Membership Renewal Notification',
      template: 'renewal.cfm',
      mUser: mUser
    );
    mMailer.send();
  }


  public void function SendPaymentReceived(required Users mUser) {
    var mMailer = new app.services.email.Emailer(
      to: mUser.email(),
      subject: 'NeonMakersGuild.org Membership Renewed',
      bcc: 'membership@neonmakersguild.org',
      template: 'paid.cfm',
      mUser: mUser
    );
    mMailer.send();
  }

  public void function SendSubscriptions(required struct data) {
    var mUser = new app.models.Users().find(data.usid);
    var kill_link = application.urls.root & '/unsubscribe?usid=' & mUser.encoded_key();
    var mMailer = new app.services.email.Emailer(
      from: 'subscriptions@neonmakersguild.org',
      to: mUser.email(),
      subject: 'NeonMakersGuild.org Subscription Notification',
      template: 'subscriptions.cfm',
      messages: data.messages,
      kill_link: kill_link,
      firstname: mUser.UserProfile().firstname()
    );
    mMailer.send();
  }

  public void function SendWelcome(required Users mUser, required string pwd) {
    var mMailer = new app.services.email.Emailer(
      to: mUser.email(),
      subject: 'Welcome to the Neon Makers Guild!',
      template: 'user_welcome.cfm',
      temp_pwd: pwd,
      mUser: mUser
    );

    mMailer.send();
  }

  // PRIVATE

  private string function email_to(required Users mUser) {
    return application.isDevelopment ? application.email.admin : mUser.email();
  }
}
