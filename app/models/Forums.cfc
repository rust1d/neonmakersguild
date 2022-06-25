component extends=BaseModel accessors=true {
  property name='fo_foid'         type='numeric'  sqltype='integer'  primary_key;
  property name='fo_name'         type='string'   sqltype='varchar';
  property name='fo_alias'        type='string'   sqltype='varchar';
  property name='fo_description'  type='string'   sqltype='varchar';
  property name='fo_active'       type='numeric'  sqltype='tinyint'  default='1';
  property name='fo_admin'        type='numeric'  sqltype='tinyint'  default='0';
  property name='fo_order'        type='numeric'  sqltype='integer'  default='0';
  property name='fo_threads'      type='numeric'  sqltype='integer'  default='0';
  property name='fo_messages'     type='numeric'  sqltype='integer'  default='0';
  property name='fo_last_fmid'    type='numeric'  sqltype='integer';

  has_many(class: 'ForumThreads',     key: 'fo_foid',  relation: 'ft_foid');

  public ForumMessages function last_message() {
    if (isNull(variables.fo_last_fmid)) return new app.models.ForumMessages();
    return new app.models.ForumMessages().find(fo_last_fmid);
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
}
