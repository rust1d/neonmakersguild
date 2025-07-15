component extends=BaseModel accessors=true {
  property name='us_usid'         type='numeric'  sqltype='integer'    primary_key;
  property name='us_user'         type='string'   sqltype='varchar';
  property name='us_password'     type='string'   sqltype='varchar';
  property name='us_email'        type='string'   sqltype='varchar';
  property name='us_permissions'  type='numeric'  sqltype='tinyint'    default='0';
  property name='us_renewal'      type='date'     sqltype='timestamp'; // DATE LAST RENEWAL, NEXT IS +1 YEAR
  property name='us_deleted'      type='date'     sqltype='timestamp';
  property name='us_added'        type='date';
  property name='us_dla'          type='date';
  property name='us_dll'          type='date';
  property name='password'        type='string';

  has_one(class: 'UserProfile',     key: 'us_usid',  relation: 'up_usid');
  has_many(class: 'UserImages',     key: 'us_usid',  relation: 'ui_usid');
  has_many(class: 'BlogComments',   key: 'us_usid',  relation: 'bco_usid');
  has_many(class: 'BlogEntries',    key: 'us_usid',  relation: 'ben_usid');
  has_many(class: 'BlogUserRoles',  key: 'us_usid',  relation: 'bur_usid');
  has_many(class: 'Notes',          key: 'us_usid',  relation: 'no_usid');
  has_many(class: 'Subscriptions',  key: 'us_usid',  relation: 'ss_usid');

  // USERS BLOG
  has_many(name: 'Categories',   class: 'BlogCategories',  key: 'us_usid',  relation: 'bca_blog');
  has_many(name: 'Documents',    class: 'Documents',       key: 'us_usid',  relation: 'doc_blog');
  has_many(name: 'Entries',      class: 'BlogEntries',     key: 'us_usid',  relation: 'ben_blog');
  has_many(name: 'Links',        class: 'BlogLinks',       key: 'us_usid',  relation: 'bli_blog');
  has_many(name: 'Tags',         class: 'Tags',            key: 'us_usid',  relation: 'tag_blog');
  has_many(name: 'UserRoles',    class: 'BlogUserRoles',   key: 'us_usid',  relation: 'bur_blog');

  public Blog function blog() {
    return variables._blog = variables._blog ?: new app.services.user.Blog(us_usid, this);
  }

  public array function bookmark_links() {
    return variables._bookmark_links = variables._bookmark_links ?: blog().links(bli_type: 'bookmark').rows;
  }

  public struct function counts() {
    var sproc = new StoredProc(procedure: 'user_counts', datasource: datasource());
    sproc.addParam(cfsqltype: 'integer', value: us_usid);
    sproc.addProcResult(name: 'qry', resultset: 1);
    var data = sproc.execute().getProcResultSets().qry.getRow(1);
    data.activity_cnt = data.recent_post_cnt + data.recent_comment_cnt + data.recent_thread_cnt + data.recent_message_cnt;
    return data;
  }

  public numeric function grace_period_remaining() {
    var grace_period = 42;
    return max(0, grace_period-past_due_days());
  }

  public date function last_reminder() {
    var rows = this.Notes().filter(row => row.action()=='send_reminder');
    return rows.len() ? rows.first().added() : mUser.renewal();
  }

  public date function next_renewal() {
    return dateAdd('yyyy', 1, variables.us_renewal).format('yyyy-mm-dd');
  }

  public boolean function past_due() {
    return past_due_days() > 0;
  }

  public numeric function past_due_days() {
    return now().diff('d', variables.us_renewal)-365;
  }

  public ProfileImage function profile_image() {
    return variables._profile_image = variables._profile_image ?: new app.services.user.ProfileImage(us_usid);
  }

  public array function profile_links() {
    return website_links().append(social_links(), true);
  }

  public query function recent_activity(struct params) {
    if (arguments.keyExists('params')) arguments = arguments.params;
    var sproc = new StoredProc(procedure: 'user_recentActivity', datasource: datasource());
    sproc.addParam(cfsqltype: 'integer', value: us_usid);
    sproc.addParam(cfsqltype: 'varchar', value: arguments.get('term'), null: !arguments.keyExists('term'));
    sproc.addProcResult(name: 'qry', resultset: 1);
    return paged_search(sproc, arguments);
  }

  public array function recently_posting(struct params) {
    if (arguments.keyExists('params')) arguments = arguments.params;
    param arguments.limit = 10;
    var sproc = new StoredProc(procedure: 'users_recently_posting', datasource: datasource());
    sproc.addParam(cfsqltype: 'integer', value: arguments.limit);
    sproc.addProcResult(name: 'qry', resultset: 1);
    var qry = sproc.execute().getProcResultSets().qry;
    return this.wrap(qry);
  }

  public query function search(struct params) {
    if (arguments.keyExists('params')) arguments = arguments.params;
    if (!isNumeric(arguments.get('maxrows'))) arguments.maxrows = -1;

    var sproc = new StoredProc(procedure: 'users_search', datasource: datasource());
    sproc.addParam(cfsqltype: 'integer', value: arguments.get('us_usid'),       null: !arguments.keyExists('us_usid'));
    sproc.addParam(cfsqltype: 'varchar', value: arguments.get('us_user'),       null: !arguments.keyExists('us_user'));
    sproc.addParam(cfsqltype: 'varchar', value: arguments.get('us_email'),      null: !arguments.keyExists('us_email'));
    sproc.addParam(cfsqltype: 'tinyint', value: arguments.get('isdeleted'),     null: !arguments.keyExists('isdeleted'));
    sproc.addParam(cfsqltype: 'integer', value: arguments.get('days_past_due'), null: !arguments.keyExists('days_past_due'));
    sproc.addParam(cfsqltype: 'tinyint', value: arguments.get('exclude'),       null: !arguments.keyExists('exclude'));
    sproc.addParam(cfsqltype: 'varchar', value: arguments.get('term'),          null: !arguments.keyExists('term'));
    sproc.addProcResult(name: 'qry', resultset: 1, maxrows: arguments.maxrows);

    return paged_search(sproc, arguments);
  }

  public string function seo_link() {
    return lcase('/member/#utility.slug(variables.us_user)#');
  }

  public array function social_links() {
    return variables._social_links = variables._social_links ?: blog().links(bli_type: 'social media').rows;
  }

  public void function update_last_login() {
    if (new_record()) return;

    var sproc = new StoredProc(procedure: 'users_update_dll', datasource: datasource());
    sproc.addParam(cfsqltype: 'integer', value: variables.us_usid);
    sproc.execute();
  }

  public array function website_links() {
    return variables._website_links = variables._website_links ?: blog().links(bli_type: 'website').rows;
  }

  // PRIVATE

  private void function pre_save() {
    if (!IsNull(password) && password.trim().len()) {
      variables.us_password = application.bcrypt.hashpw(password);
      variables.password = '';
    }
    if (this.user_changed()) {
      var qry = this.search(us_user: variables.us_user);
      if (qry.len() && qry.us_usid != primary_key()) {
        errors().append('Username #variables.us_user# is in use.');
      }
    }
  }
}
