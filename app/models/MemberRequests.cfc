component extends=BaseModel accessors=true {
  property name='mr_mrid'        type='numeric'  sqltype='integer'    primary_key;
  property name='mr_firstname'   type='string'   sqltype='varchar';
  property name='mr_lastname'    type='string'   sqltype='varchar';
  property name='mr_email'       type='string'   sqltype='varchar';
  property name='mr_phone'       type='string'   sqltype='varchar';
  property name='mr_location'    type='string'   sqltype='varchar';
  property name='mr_address1'    type='string'   sqltype='varchar';
  property name='mr_address2'    type='string'   sqltype='varchar';
  property name='mr_city'        type='string'   sqltype='varchar';
  property name='mr_region'      type='string'   sqltype='varchar';
  property name='mr_postal'      type='string'   sqltype='varchar';
  property name='mr_country'     type='string'   sqltype='varchar';
  property name='mr_website1'    type='string'   sqltype='varchar';
  property name='mr_website2'    type='string'   sqltype='varchar';
  property name='mr_history'     type='string'   sqltype='varchar';
  property name='mr_promo'       type='string'   sqltype='varchar';
  property name='mr_user'        type='string'   sqltype='varchar';
  property name='mr_usid'        type='numeric'  sqltype='integer';
  property name='mr_deleted_by'  type='numeric'  sqltype='integer';
  property name='mr_deleted'     type='date'     sqltype='timestamp';
  property name='mr_validated'   type='date'     sqltype='timestamp';
  property name='mr_accepted'    type='date'     sqltype='timestamp';
  property name='mr_added'       type='date';
  property name='mr_dla'         type='date';

  public boolean function accept_sent() {
    return !isNull(variables.mr_accepted);
  }

  public boolean function convert() {
    if (!isNull(variables.mr_usid)) return application.flash.error('Member Request already converted.');
    if (!isNull(variables.mr_deleted)) return application.flash.error('Member Request deleted.');
    var pwd = generate_password();
    var mUser = new app.models.Users({
      us_user: mr_user,
      us_email: mr_email,
      us_permissions: 0,
      password: pwd
    });
    if (mUser.safe_save()) {
      variables.mr_usid = mUser.usid();
      variables.mr_deleted_by = session.user.usid();
      variables.mr_deleted = now();
      safe_save();
      var mUP = mUser.UserProfile(build: {
        up_firstname: mr_firstname,
        up_lastname: mr_lastname,
        up_bio: mr_history,
        up_location: mr_location,
        up_address1: mr_address1,
        up_address2: mr_address2,
        up_city: mr_city,
        up_region: mr_region,
        up_postal: mr_postal,
        up_country: mr_country,
        up_phone: mr_phone,
        up_promo: mr_promo
      });
      if (mUP.safe_save()) {
        new app.services.email.UserEmailer().SendWelcome(mUser, pwd);
        return true;
      }
    }
    return application.flash.error('User creation failed.');
  }

  public boolean function delete() {
    variables.mr_deleted_by = session.user.usid();
    variables.mr_deleted = now();
    return safe_save();
  }

  public boolean function email_validated() {
    return !isNull(variables.mr_validated);
  }

  public query function search(struct params) {
    if (arguments.keyExists('params')) arguments = arguments.params;
    if (!isNumeric(arguments.get('maxrows'))) arguments.maxrows = -1;

    var sproc = new StoredProc(procedure: 'memberrequests_search', datasource: datasource());
    sproc.addParam(cfsqltype: 'integer', value: arguments.get('mr_mrid'), null: !arguments.keyExists('mr_mrid'));
    sproc.addProcResult(name: 'qry', resultset: 1, maxrows: arguments.maxrows);
    return paged_search(sproc, arguments);
  }

  public boolean function validate_email() {
    variables.mr_validated = now();
    return safe_save();
  }

  // PRIVATE

  private string function generate_password() {
    return utility.slug(mr_email.listFirst('@') & '$' & mr_mrid);
  }

  private void function pre_save() {
    if (this.email_changed()) {
      variables.mr_email = variables.mr_email.lcase();
    }

    if (this.user_changed()) {
      if (new app.models.Users().search(us_user: mr_user).len()) {
        errors().append('Username #mr_user# is taken. Please choose another.');
      }
    }
  }
}