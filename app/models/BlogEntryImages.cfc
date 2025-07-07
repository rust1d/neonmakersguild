component extends=BaseModel accessors=true {
  property name='bei_beiid'        type='numeric'  sqltype='integer'  primary_key;
  property name='bei_benid'        type='numeric'  sqltype='integer';
  property name='bei_uiid'         type='numeric'  sqltype='integer';
  property name='bei_caption'      type='string'   sqltype='varchar';
  property name='bei_comment_cnt'  type='numeric';

  belongs_to(name: 'BlogEntry',    class: 'BlogEntries',     key: 'bei_benid', relation: 'ben_benid', preloaded: true);
  belongs_to(name: 'UserImage',    class: 'UserImages',      key: 'bei_uiid',  relation: 'ui_uiid',   preloaded: true);
  has_many  (name: 'BlogComments', class: 'BlogComments',    key: 'bei_beiid', relation: 'bco_beiid');

  public BaseModel function find_nav(required numeric bei_beiid, numeric direction) {
    load_db(search(arguments));
    if (!persisted()) throw('Record not found.', 'record_not_found');

    return this;
  }

  public query function search(struct params) {
    if (arguments.keyExists('params')) arguments = arguments.params;
    if (!isNumeric(arguments.get('maxrows'))) arguments.maxrows = -1;

    var sproc = new StoredProc(procedure: 'blogentryimages_search', datasource: datasource());
    sproc.addParam(cfsqltype: 'integer', value: arguments.get('bei_beiid'),   null: !arguments.keyExists('bei_beiid'));
    sproc.addParam(cfsqltype: 'integer', value: arguments.get('bei_benid'),   null: !arguments.keyExists('bei_benid'));
    sproc.addParam(cfsqltype: 'integer', value: arguments.get('bei_uiid'),    null: !arguments.keyExists('bei_uiid'));
    sproc.addParam(cfsqltype: 'integer', value: arguments.get('direction'),   null: !arguments.keyExists('direction'));
    sproc.addProcResult(name: 'qry', resultset: 1, maxrows: arguments.maxrows);
    return sproc.execute().getProcResultSets().qry;
  }
}
