component extends=BaseModel accessors=true {
  property name='bco_bcoid'          type='numeric'  sqltype='integer'    primary_key;
  property name='bco_blog'           type='numeric'  sqltype='integer';
  property name='bco_benid'          type='numeric'  sqltype='integer';
  property name='ben_usid'           type='numeric'  sqltype='integer';
  property name='bco_name'           type='string'   sqltype='varchar';
  property name='bco_email'          type='string'   sqltype='varchar';
  property name='bco_comment'        type='string'   sqltype='varchar';
  property name='bco_posted'         type='date'     sqltype='timestamp';
  property name='bco_subscribe'      type='numeric'  sqltype='tinyint';
  property name='bco_website'        type='string'   sqltype='varchar';
  property name='bco_moderated'      type='numeric'  sqltype='tinyint';
  property name='bco_subscribeonly'  type='numeric'  sqltype='tinyint';
  property name='bco_kill'           type='string'   sqltype='varchar';

  belongs_to(name: 'User',      class: 'Users',        key: 'ben_usid', relation: 'us_usid');
  belongs_to(name: 'BlogEntry', class: 'BlogEntries',  key: 'bco_benid', relation: 'ben_benid');

  public query function search(struct params) {
    if (arguments.keyExists('params')) arguments = arguments.params;
    if (!isNumeric(arguments.get('maxrows'))) arguments.maxrows = -1;

    var sproc = new StoredProc(procedure: 'blogcomments_search', datasource: datasource());
    sproc.addParam(cfsqltype: 'integer',   value: arguments.get('bco_bcoid'),     null: !arguments.keyExists('bco_bcoid'));
    sproc.addParam(cfsqltype: 'integer',   value: arguments.get('bco_blog'),      null: !arguments.keyExists('bco_blog'));
    sproc.addParam(cfsqltype: 'integer',   value: arguments.get('bco_benid'),     null: !arguments.keyExists('bco_benid'));
    sproc.addParam(cfsqltype: 'varchar',   value: arguments.get('bco_name'),      null: !arguments.keyExists('bco_name'));
    sproc.addParam(cfsqltype: 'varchar',   value: arguments.get('bco_email'),     null: !arguments.keyExists('bco_email'));
    sproc.addParam(cfsqltype: 'timestamp', value: arguments.get('bco_posted'),    null: !arguments.keyExists('bco_posted'));
    sproc.addParam(cfsqltype: 'tinyint',   value: arguments.get('bco_moderated'), null: !arguments.keyExists('bco_moderated'));
    sproc.addProcResult(name: 'qry', resultset: 1, maxrows: arguments.maxrows);

    return sproc.execute().getProcResultSets().qry;
  }
}
