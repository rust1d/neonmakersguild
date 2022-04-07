component extends=BaseModel accessors=true {
  property name='us_usid'         type='numeric'  sqltype='integer'    primary_key;
  property name='us_email'        type='string'   sqltype='varchar';
  property name='us_password'     type='string'   sqltype='varchar';
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


  public query function search(struct params) {
    if (arguments.keyExists('params')) arguments = arguments.params;
    if (!isNumeric(arguments.get('maxrows'))) arguments.maxrows = -1;

    var sproc = new StoredProc(procedure: 'users_search', datasource: datasource());
    sproc.addParam(cfsqltype: 'integer', value: arguments.get('us_usid'),  null: !arguments.keyExists('us_usid'));
    sproc.addParam(cfsqltype: 'varchar', value: arguments.get('us_email'), null: !arguments.keyExists('us_email'));
    sproc.addProcResult(name: 'qry', resultset: 1, maxrows: arguments.maxrows);

    return sproc.execute().getProcResultSets().qry;
  }

  private void function pre_save() {
    if (!IsNull(password) && password.trim().len()) {
      variables.us_password = application.bcrypt.hashpw(password);
      variables.password = '';
    }
  }

  public ProfileImage function profile_image() {
    return variables._profile_image = variables._profile_image ?: new services.user.ProfileImage(us_usid);
  }
}
