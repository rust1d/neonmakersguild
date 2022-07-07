component {
  public MemberRequestEmailer function init() {
    variables.router = request.router;
    variables.utility = application.utility;
    return this;
  }

  public void function SendAccept(required MemberRequests mMR) {
    var send_to = application.isDevelopment ? application.email.admin : mMR.email();
    var mMailer = new app.services.email.Emailer(
      to: send_to,
      testmode: true,
      subject: 'Your NeonMakersGuild.org Member Request',
      template: 'request_accept.cfm',
      mMR: mMR
    );

    mMailer.send();
  }

  public void function SendConfirmation(required MemberRequests mMR) {
    var send_to = application.isDevelopment ? application.email.admin : mMR.email();
    var mMailer = new app.services.email.Emailer(
      to: send_to,
      testmode: true,
      subject: 'Your NeonMakersGuild.org Member Request',
      template: 'request_confirm.cfm',
      mMR: mMR
    );

    mMailer.send();
  }
}
