component extends=jsoup accessors=true {
  property name='fm_fmid'        type='numeric'  sqltype='integer'    primary_key;
  property name='fm_foid'        type='numeric'  sqltype='integer';
  property name='fm_ftid'        type='numeric'  sqltype='integer';
  property name='fm_usid'        type='numeric'  sqltype='integer';
  property name='fm_body'        type='string'   sqltype='varchar'    html;
  property name='fm_history'     type='string'   sqltype='varchar';
  property name='fm_deleted_by'  type='numeric'  sqltype='integer';
  property name='fm_deleted'     type='date'     sqltype='timestamp';
  property name='fm_added'       type='date';
  property name='fm_dla'         type='date';
  property name='fo_alias'       type='string';
  property name='ft_alias'       type='string';
  property name='us_user'        type='string';

  belongs_to(name: 'Forum',        class: 'Forums',        key: 'fm_foid',  relation: 'fo_foid');
  belongs_to(name: 'ForumThread',  class: 'ForumThreads',  key: 'fm_ftid',  relation: 'ft_ftid');
  belongs_to(name: 'User',         class: 'Users',         key: 'fm_usid',  relation: 'us_usid');
  has_many  (name: 'ForumImages',  class: 'ForumImages',   key: 'fm_fmid',  relation: 'fi_fmid');

  public numeric function age() {
    return now().diff('h', fm_added ?: now());
  }

  public boolean function editable() {
    return age() <= 24 && !deleted();
  }

  public boolean function deleted() {
    return !isNull(variables.fm_deleted);
  }

  public Users function deleted_by() {
    return variables._deleted_by = variables._deleted_by ?: new app.models.Users().find(fm_deleted_by);
  }

  public string function deleted_label() {
    return 'Deleted by #deleted_by().user()# on #deleted_on()#';
  }

  public string function deleted_on() {
    return isNull(variables.fm_deleted) ? '' : utility.ordinalDate(fm_deleted) & fm_deleted.format(' @ HH:nn');
  }

  public array function list(struct params) {
    if (arguments.keyExists('params')) arguments = arguments.params;
    if (!isNumeric(arguments.get('maxrows'))) arguments.maxrows = -1;
    var sproc = new StoredProc(procedure: 'forummessages_list', datasource: datasource());
    sproc.addParam(cfsqltype: 'integer', value: arguments.get('fm_ftid'),  null: !arguments.keyExists('fm_ftid'));
    sproc.addParam(cfsqltype: 'integer', value: arguments.get('deleted'),  null: !arguments.keyExists('deleted'));
    sproc.addParam(cfsqltype: 'varchar', value: arguments.get('term'),     null: !arguments.keyExists('term'));
    sproc.addProcResult(name: 'qry', resultset: 1, maxrows: arguments.maxrows);

    return preserveNulls(paged_search(sproc, arguments));
  }

  public string function more() {
    if (isNull(variables.fm_body)) return '';
    var data = words().toList().left(30).listToArray();
    return utility.slice(data, max(3, max(data.len()-1, 1))).toList(' ') & '&hellip;';
  }

  public string function posted() {
    if (new_record()) return '';
    return utility.recentDate(variables.fm_added, 10);
  }

  public string function posted_short() {
    if (new_record()) return '';
    if (utility.days_passed(variables.fm_added) <= 1) return variables.fm_added.format('HH:nn');
    return variables.fm_added.format('mm/dd/yy');
  }

  public boolean function repost() {
    if (persisted()) return true;
    var sproc = new StoredProc(procedure: 'forummessages_last_post', datasource: datasource());
    sproc.addParam(cfsqltype: 'integer', value: variables.fm_foid);
    sproc.addParam(cfsqltype: 'integer', value: variables.fm_ftid);
    sproc.addParam(cfsqltype: 'integer', value: variables.fm_usid);
    sproc.addProcResult(name: 'qry', resultset: 1);
    var qry = sproc.execute().getProcResultSets().qry;
    if (qry.len()==0) return false;
    return now().diff('n', qry.fm_added) < 1 && qry.fm_body == variables.fm_body;
  }

  public query function search(struct params) {
    if (arguments.keyExists('params')) arguments = arguments.params;
    if (!isNumeric(arguments.get('maxrows'))) arguments.maxrows = -1;
    var sproc = new StoredProc(procedure: 'forummessages_search', datasource: datasource());
    sproc.addParam(cfsqltype: 'integer', value: arguments.get('fm_fmid'),  null: !arguments.keyExists('fm_fmid'));
    sproc.addParam(cfsqltype: 'integer', value: arguments.get('fm_foid'),  null: !arguments.keyExists('fm_foid'));
    sproc.addParam(cfsqltype: 'integer', value: arguments.get('fm_ftid'),  null: !arguments.keyExists('fm_ftid'));
    sproc.addParam(cfsqltype: 'integer', value: arguments.get('fm_usid'),  null: !arguments.keyExists('fm_usid'));
    sproc.addParam(cfsqltype: 'integer', value: arguments.get('deleted'),  null: !arguments.keyExists('deleted'));
    sproc.addParam(cfsqltype: 'varchar', value: arguments.get('term'),     null: !arguments.keyExists('term'));
    sproc.addProcResult(name: 'qry', resultset: 1, maxrows: arguments.maxrows);

    return paged_search(sproc, arguments);
  }

  public string function seo_link() {
    if (new_record()) return 'forum/404';
    // if (isNull(this.ForumThread())) return 'forum/404';
    if (isNull(variables.ft_alias)) variables.ft_alias = this.ForumThread().alias();
    if (isNull(variables.fo_alias)) variables.fo_alias = this.ForumThread().fo_alias();

    return '/forum/#fo_alias#/#fm_ftid#/#ft_alias####fm_fmid#';
  }

  // PRIVATE

  private void function post_insert(required boolean success) {
    if (arguments.success) {
      new app.models.Subscriptions().alert(ss_fkey: variables.fm_ftid, ss_table: 'ForumThreads');
      notify_thread_owner();
      parse_mentions();
    }
  }

  private void function notify_thread_owner() {
    var thread = this.ForumThread();
    if (thread.usid() == variables.fm_usid) return;
    new app.models.UserNotifications().notify(
      usid: thread.usid(),
      type: 'reply',
      message: session.user.user() & ' replied to your thread ' & thread.subject(),
      data: {
        from_usid: variables.fm_usid,
        from_user: session.user.user(),
        ref_id: variables.fm_fmid,
        link: seo_link()
      }
    );
  }

  private void function parse_mentions() {
    var body = variables.fm_body ?: '';
    var matches = body.reMatch('@[a-zA-Z][a-zA-Z0-9_-]+');
    var notifier = new app.models.UserNotifications();
    var thread = this.ForumThread();

    for (var mention in matches) {
      var username = mention.mid(2, mention.len() - 1);
      var mUsers = new app.models.Users().where(us_user: username);
      if (mUsers.len() == 1) {
        var mMentioned = mUsers[1];
        if (mMentioned.usid() == variables.fm_usid) continue;
        notifier.notify(
          usid: mMentioned.usid(),
          type: 'mention',
          message: session.user.user() & ' mentioned you in ' & thread.subject(),
          data: {
            from_usid: variables.fm_usid,
            from_user: session.user.user(),
            ref_id: variables.fm_fmid,
            link: seo_link()
          }
        );
      }
    }
  }
}
