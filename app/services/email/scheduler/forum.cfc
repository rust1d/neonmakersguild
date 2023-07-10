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

  private struct function build_messages(boolean testing=false) {
    var msgs = {}
    var rows = new app.models.Subscriptions().alerts(); // ss_table: 'ForumThreads', ss_usid: 0
    var foids = {};
    for (var row in rows) {
      var mAlert = new app.models.Subscriptions(row);
      var recent_users = row.al_users_posting.listToArray().toList(', ').reReplace(',(?=[^,]+$)', ', and ');
      var data = user_data(msgs, mAlert.usid());
      if (mAlert.table()=='Forums') {
        var mForum = mAlert.model();
        data.messages.append('There is new activity in the forum <a href="#application.urls.root##mForum.seo_link()#" target=_blank>`#mForum.name()#`</a> by #recent_users#');
      } else if (mAlert.table()=='ForumThreads') {
        var mThread = mAlert.model();
        var mForum = mThread.forum();
        data.messages.append('There is new activity in the forum thread <a href="#application.urls.root##mThread.seo_link()#" target=_blank>`#mForum.name()# - #mThread.subject()#`</a> by #recent_users#');
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
