component extends=BaseModel accessors=true {
  property name='us_usid'         type='numeric'  sqltype='integer'    primary_key;
  property name='us_user'         type='string'   sqltype='varchar';
  property name='us_password'     type='string'   sqltype='varchar';
  property name='us_email'        type='string'   sqltype='varchar';
  property name='us_permissions'  type='numeric'  sqltype='tinyint'    default='0';
  property name='us_active'       type='numeric'  sqltype='tinyint'    default='1';
  property name='us_deleted'      type='numeric'  sqltype='tinyint'    default='0';
  property name='us_added'        type='date';
  property name='us_dla'          type='date';
  property name='password'        type='string';

  has_one(class: 'UserProfile',     key: 'us_usid',  relation: 'up_usid');
  has_many(class: 'UserImages',     key: 'us_usid',  relation: 'ui_usid');
  has_many(class: 'UserLinks',      key: 'us_usid',  relation: 'ul_usid');
  has_many(class: 'BlogEntries',    key: 'us_usid',  relation: 'ben_usid');
  has_many(class: 'BlogUserRoles',  key: 'us_usid',  relation: 'bur_usid');
  has_many(class: 'BlogComments',  key: 'us_usid',  relation: 'bco_usid');

  // USERS BLOG
  has_many(name: 'Categories',   class: 'BlogCategories',  key: 'us_usid',  relation: 'bca_blog');
  has_many(name: 'Comments',     class: 'BlogComments',    key: 'us_usid',  relation: 'bco_blog');
  has_many(name: 'Entries',      class: 'BlogEntries',     key: 'us_usid',  relation: 'ben_blog');
  has_many(name: 'UserRoles',    class: 'BlogUserRoles',   key: 'us_usid',  relation: 'bur_blog');

  public query function search(struct params) {
    if (arguments.keyExists('params')) arguments = arguments.params;
    if (!isNumeric(arguments.get('maxrows'))) arguments.maxrows = -1;

    var sproc = new StoredProc(procedure: 'users_search', datasource: datasource());
    sproc.addParam(cfsqltype: 'integer', value: arguments.get('us_usid'),  null: !arguments.keyExists('us_usid'));
    sproc.addParam(cfsqltype: 'varchar', value: arguments.get('us_user'), null: !arguments.keyExists('us_user'));
    sproc.addParam(cfsqltype: 'varchar', value: arguments.get('us_email'), null: !arguments.keyExists('us_email'));
    sproc.addProcResult(name: 'qry', resultset: 1, maxrows: arguments.maxrows);

    return sproc.execute().getProcResultSets().qry;
  }

  private void function pre_save() {
    if (!IsNull(password) && password.trim().len()) {
      variables.us_password = application.bcrypt.hashpw(password);
      variables.password = '';
    }
    if (this.user_changed()) {
      var qry = this.search(us_user: us_user);
      if (qry.len() && qry.us_usid != primary_key()) {
        errors().append('Username #us_user# is in use.');
      }
    }
  }

  public ProfileImage function profile_image() {
    return variables._profile_image = variables._profile_image ?: new services.user.ProfileImage(us_usid);
  }

  public string function seo_link() {
    return '/author/#us_usid#/#us_user#';
  }
}
