component extends=BaseModel accessors=true {
  property name='bur_burid'  type='numeric'  sqltype='integer'  primary_key;
  property name='bur_usid'   type='numeric'  sqltype='integer';
  property name='bur_broid'  type='numeric'  sqltype='integer';
  property name='bur_blog'   type='numeric'  sqltype='integer';

  public query function search(struct params) {
    if (arguments.keyExists('params')) arguments = arguments.params;
    if (!isNumeric(arguments.get('maxrows'))) arguments.maxrows = -1;

    var sproc = new StoredProc(procedure: 'bloguserroles_search', datasource: datasource());
    sproc.addParam(cfsqltype: 'integer', value: arguments.get('bur_burid'), null: !arguments.keyExists('bur_burid'));
    sproc.addParam(cfsqltype: 'integer', value: arguments.get('bur_usid'),  null: !arguments.keyExists('bur_usid'));
    sproc.addParam(cfsqltype: 'integer', value: arguments.get('bur_broid'), null: !arguments.keyExists('bur_broid'));
    sproc.addParam(cfsqltype: 'integer', value: arguments.get('bur_blog'),  null: !arguments.keyExists('bur_blog'));
    sproc.addProcResult(name: 'qry', resultset: 1, maxrows: arguments.maxrows);

    return sproc.execute().getProcResultSets().qry;
  }
}
