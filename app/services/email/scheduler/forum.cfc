component {
  public boolean function send_alerts(boolean testing=false) {
    var msgs = build_messages(testing);
    var mailer = new app.services.email.UserEmailer();
    for (var key in msgs) {
      var row = msgs[key];
      mailer.SendSubscriptions(row);
    }

    return true;
  }

  // PRIVATE

  private struct function build_messages(boolean testing=true) {
    var msgs = {}
    var mAlerts = new app.models.Subscriptions().alerts(ss_table: 'ForumThreads');
    var foids = {};
    for (var mAlert in mAlerts) {
      var mThread = mAlert.model();
      var mForum = mThread.forum();
      foids[mForum.foid()] = foids[mForum.foid()] ?: 0;
      // CHECK FORUM LEVEL SUBSCRIPTIONS FIRST
      for (var mSubscription in mForum.Subscriptions()) {
        foids[mForum.foid()]++;
        if (foids[mForum.foid()]!=1) continue; // ALREADY PROCESSED THIS FORUM;
        if (mSubscription.owner(mForum.last_message().usid())) continue; // SKIP IF USER LAST POSTER

        var data = user_data(msgs, mSubscription.usid());
        data.messages.append('There is new activity in the forum <a href="#application.urls.root##mForum.seo_link()#" target=_blank>`#mForum.name()#`</a>');
      }

      for (var mSubscription in mThread.Subscriptions()) {
        if (mSubscription.owner(mThread.last_message().usid())) continue; // SKIP IF USER LAST POSTER

        var data = user_data(msgs, mSubscription.usid());
        data.messages.append('There is new activity in the forum thread <a href="#application.urls.root##mThread.seo_link()#" target=_blank>`#mForum.name()# - #mThread.subject()#`</a>');
      }
      if (testing==false) mAlert.destroy();
    }
    return msgs;
  }

  private struct function user_data(required struct data, required numeric usid) {
    if (!data.keyExists(usid)) data[usid] = { messages: [], usid: usid };

    return data[usid];
  }
}
