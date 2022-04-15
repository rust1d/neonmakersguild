component extends=BaseModel accessors=true {
  property name='bsu_bsuid'     type='numeric'  sqltype='integer'  primary_key;
  property name='bsu_email'     type='string'   sqltype='varchar';
  property name='bsu_token'     type='string'   sqltype='varchar';
  property name='bsu_blog'      type='numeric'  sqltype='integer';
  property name='bsu_verified'  type='numeric'  sqltype='tinyint';

  public query function search(struct params) {
    if (arguments.keyExists('params')) arguments = arguments.params;
    if (!isNumeric(arguments.get('maxrows'))) arguments.maxrows = -1;

    var sproc = new StoredProc(procedure: 'blogsubscribers_search', datasource: datasource());
    sproc.addParam(cfsqltype: 'integer', value: arguments.get('bsu_bsuid'),    null: !arguments.keyExists('bsu_bsuid'));
    sproc.addParam(cfsqltype: 'varchar', value: arguments.get('bsu_email'),    null: !arguments.keyExists('bsu_email'));
    sproc.addParam(cfsqltype: 'varchar', value: arguments.get('bsu_token'),    null: !arguments.keyExists('bsu_token'));
    sproc.addParam(cfsqltype: 'integer', value: arguments.get('bsu_blog'),     null: !arguments.keyExists('bsu_blog'));
    sproc.addParam(cfsqltype: 'tinyint', value: arguments.get('bsu_verified'), null: !arguments.keyExists('bsu_verified'));
    sproc.addProcResult(name: 'qry', resultset: 1, maxrows: arguments.maxrows);

    return sproc.execute().getProcResultSets().qry;
  }
}
