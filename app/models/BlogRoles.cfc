component extends=BaseModel accessors=true {
  property name='bro_broid'        type='numeric'  sqltype='integer'  primary_key;
  property name='bro_role'         type='string'   sqltype='varchar';
  property name='bro_description'  type='string'   sqltype='varchar';

  public query function search(struct params) {
    if (arguments.keyExists('params')) arguments = arguments.params;
    if (!isNumeric(arguments.get('maxrows'))) arguments.maxrows = -1;

    var sproc = new StoredProc(procedure: 'blogroles_search', datasource: datasource());
    sproc.addParam(cfsqltype: 'integer', value: arguments.get('bro_broid'), null: !arguments.keyExists('bro_broid'));
    sproc.addParam(cfsqltype: 'varchar', value: arguments.get('bro_role'),  null: !arguments.keyExists('bro_role'));
    sproc.addProcResult(name: 'qry', resultset: 1, maxrows: arguments.maxrows);

    return sproc.execute().getProcResultSets().qry;
  }
}
