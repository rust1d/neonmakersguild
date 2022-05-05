component extends=BaseModel accessors=true {
  property name='us_usid'         type='numeric'  sqltype='integer'    primary_key;
  property name='us_user'         type='string'   sqltype='varchar';
  property name='us_password'     type='string'   sqltype='varchar';
  property name='us_email'        type='string'   sqltype='varchar';
  property name='us_permissions'  type='numeric'  sqltype='tinyint'    default='0';
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

  // USERS BLOG
  has_many(name: 'Categories',   class: 'BlogCategories',  key: 'us_usid',  relation: 'bca_blog');
  // has_many(name: 'Comments',     class: 'BlogComments',    key: 'us_usid',  relation: 'bco_blog');
  has_many(name: 'Entries',      class: 'BlogEntries',     key: 'us_usid',  relation: 'ben_blog');
  has_many(name: 'Links',        class: 'BlogLinks',       key: 'us_usid',  relation: 'bli_blog');
  has_many(name: 'UserRoles',    class: 'BlogUserRoles',   key: 'us_usid',  relation: 'bur_blog');

  public Blog function blog() {
    return variables._blog = variables._blog ?: new app.services.user.Blog(us_usid, this);
  }

  public query function search(struct params) {
    if (arguments.keyExists('params')) arguments = arguments.params;
    if (!isNumeric(arguments.get('maxrows'))) arguments.maxrows = -1;

    var sproc = new StoredProc(procedure: 'users_search', datasource: datasource());
    sproc.addParam(cfsqltype: 'integer', value: arguments.get('us_usid'),   null: !arguments.keyExists('us_usid'));
    sproc.addParam(cfsqltype: 'varchar', value: arguments.get('us_user'),   null: !arguments.keyExists('us_user'));
    sproc.addParam(cfsqltype: 'varchar', value: arguments.get('us_email'),  null: !arguments.keyExists('us_email'));
    sproc.addParam(cfsqltype: 'tinyint', value: arguments.get('isdeleted'), null: !arguments.keyExists('isdeleted'));
    sproc.addParam(cfsqltype: 'varchar', value: arguments.get('term'),      null: !arguments.keyExists('term'));
    sproc.addProcResult(name: 'qry', resultset: 1, maxrows: arguments.maxrows);

    return search_paged(sproc, arguments);
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

  public array function profile_links() {
    var data = this.Links().filter(row => row.isWebsite());
    data.append(this.Links().filter(row => row.isSocial()), true);
    return data;
  }

  public string function seo_link() {
    return lcase('/member/#us_user#');
  }

  // public array function social_links() {
  //   return this.Links().filter(row => row.isSocial());
  // }

  public void function update_last_login() {
    if (new_record()) return;

    var sproc = new StoredProc(procedure: 'users_update_dll', datasource: datasource());
    sproc.addParam(cfsqltype: 'integer', value: variables.us_usid);
    sproc.execute();
  }

  // public array function website_links() {
  //   return this.Links().filter(row => row.isWebsite());
  // }
}
