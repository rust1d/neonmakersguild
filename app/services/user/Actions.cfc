component {
  remote struct function unsubscribe() returnFormat='json' {
    try {
      var response = new_response();
      var usid = request.router.decode('usid');
      if (usid) {
        var mUser = new app.models.Users().find(usid); // CONFIRM USER EXISTS
        var cnt = new app.models.Subscriptions().delete_by_user(usid);
        var msg = application.utility.plural_label(cnt, 'subscription');
        response.data.messages = 'Found and deleted #msg#.';
        repsonse.data.usid = usid;

        var path = ExpandPath('\') & 'tmp\subscriptions.txt';
        fileAppend(path, { usid: usid, mode: 'bulk unsubscribe', cnt: cnt });
      } else {
        response.data.messages = 'You successfully deleted all requests!';
      }
      return response;
    } catch (any err) {
      return error_response(err);
    }
  }

  public Notes function LastReminder(required Users mUser) {
    var rows = mUser.Notes().filter(row => row.action()=='send_reminder');
    if (rows.len()) return rows.first();
    return mUser.Notes(build: {});
  }

  public boolean function RecentReminder(required Users mUser, numeric days=30) {
    var mNote = LastReminder(mUser);
    return application.utility.bool(mNote.persisted() && mNote.age_in_days() LTE arguments.days);
  }

  public boolean function SendReminder(required Users mUser) {
    if (SentReminder(mUser)) {
      var days = application.utility.plural_label(application.settings.renewal_reminder_cooldown, 'day');
      return application.flash.warning('A reminder was already sent in the past #days#. Please wait before sending again.');
    }

    new app.services.email.UserEmailer().SendRenewalReminder(mUser);
    return mUser.Notes(build: {}).system_action('send_reminder', 'Renewal reminder sent').safe_save();
  }

  public boolean function SentReminder(required Users mUser) {
    return RecentReminder(mUser, application.settings.renewal_reminder_cooldown);
  }

  public boolean function MarkPaid(required Users mUser) {
    mUser.renewal(now());
    if (!mUser.safe_save()) return false;
    new app.services.email.UserEmailer().SendPaymentReceived(mUser);
    mUser.Notes(build: {}).system_action('mark_paid', 'Membership marked renewed').safe_save();
    return true;
  }

  // PRIVATE

  private struct function error_response(required any err) {
    var response = new_response();
    response.success = false;
    response.errors.append(application.utility.errorString(err));
    return response;
  }

  private struct function new_response() {
    return { 'success': true, 'errors': [], 'data': {} };
  }

}