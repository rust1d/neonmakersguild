component extends=BaseModel accessors=true {
  property name='fo_foid'         type='numeric'  sqltype='integer'  primary_key;
  property name='fo_name'         type='string'   sqltype='varchar';
  property name='fo_alias'        type='string'   sqltype='varchar';
  property name='fo_description'  type='string'   sqltype='varchar';
  property name='fo_active'       type='boolean'  sqltype='tinyint'  default='1';
  property name='fo_admin'        type='boolean'  sqltype='tinyint'  default='0';
  property name='fo_private'      type='boolean'  sqltype='tinyint'  default='0';
  property name='fo_order'        type='numeric'  sqltype='integer'  default='0';
  property name='fo_threads'      type='numeric'  sqltype='integer'  default='0';
  property name='fo_messages'     type='numeric'  sqltype='integer'  default='0';
  property name='fo_last_fmid'    type='numeric'  sqltype='integer';

  has_many(class: 'ForumThreads',     key: 'fo_foid',  relation: 'ft_foid');

  public string function audience() {
    return fo_admin ? 'Admins' : fo_private ? 'Members' : 'Public';
  }

  public ForumMessages function last_message() {
    if (isNull(variables.fo_last_fmid)) return new app.models.ForumMessages();
    return variables._last_message = variables._last_message ?: new app.models.ForumMessages().find(fo_last_fmid);
  }

  public query function list(struct params) {
    if (arguments.keyExists('params')) arguments = arguments.params;
    if (!isNumeric(arguments.get('maxrows'))) arguments.maxrows = -1;

    var sproc = new StoredProc(procedure: 'forums_list', datasource: datasource());
    sproc.addParam(cfsqltype: 'integer', value: arguments.get('fo_foid'),  null: !arguments.keyExists('fo_foid'));
    sproc.addParam(cfsqltype: 'varchar', value: arguments.get('fo_alias'), null: !arguments.keyExists('fo_alias'));
    sproc.addParam(cfsqltype: 'tinyint', value: arguments.get('fo_admin'), null: !arguments.keyExists('fo_admin'));
    sproc.addProcResult(name: 'qry', resultset: 1, maxrows: arguments.maxrows);


    return sproc.execute().getProcResultSets().qry;
  }

  public query function search(struct params) {
    if (arguments.keyExists('params')) arguments = arguments.params;
    if (!isNumeric(arguments.get('maxrows'))) arguments.maxrows = -1;

    var sproc = new StoredProc(procedure: 'forums_search', datasource: datasource());
    sproc.addParam(cfsqltype: 'integer', value: arguments.get('fo_foid'),  null: !arguments.keyExists('fo_foid'));
    sproc.addParam(cfsqltype: 'varchar', value: arguments.get('fo_alias'), null: !arguments.keyExists('fo_alias'));
    sproc.addParam(cfsqltype: 'tinyint', value: arguments.get('fo_admin'), null: !arguments.keyExists('fo_admin'));
    sproc.addProcResult(name: 'qry', resultset: 1, maxrows: arguments.maxrows);

    return sproc.execute().getProcResultSets().qry;
  }

  public string function seo_link() {
    if (new_record()) return 'forum/404';

    return '/forum/#fo_alias#';
  }

  public string function subject() {
    return variables.fo_name ?: '';
  }

  public Subscriptions function subscribe(numeric usid=0) {
    var mdl = subscription(usid);
    if (mdl.new_record()) mdl.safe_save();
    return mdl;
  }

  public Subscriptions function subscription(numeric usid=0) {
    var params = { ss_usid: usid, ss_fkey: primary_key(), ss_table: class() }
    var mdl = new app.models.Subscriptions(params);
    if (new_record() || usid==0) return mdl;
    var mdls = mdl.where(params);
    return mdls.len() ? mdls.first() : mdl;
  }

  public array function subscriptions() {
    return new app.models.Subscriptions().where(ss_fkey: primary_key(), ss_table: class()).filter(row => row.usid());
  }

  public boolean function subscription_alert() {
    return new app.models.Subscriptions().alert(ss_fkey: primary_key(), ss_table: class());
  }

  public boolean function unsubscribe(numeric usid=0) {
    if (usid==0) return true;
    var mdl = subscription(usid);
    if (mdl.new_record()) return true;
    return mdl.destroy();
  }
}
