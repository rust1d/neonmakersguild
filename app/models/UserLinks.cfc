component extends=BaseModel accessors=true {
  property name='ul_ulid'  type='numeric'  sqltype='integer'    primary_key;
  property name='ul_usid'  type='numeric'  sqltype='integer';
  property name='ul_url'   type='string'   sqltype='varchar';
  property name='ul_type'  type='string'   sqltype='varchar';
  property name='ul_dla'   type='date';

  belongs_to(class: 'Users',  key: 'ul_usid', relation: 'us_usid');

  public query function search(struct params) {
    if (arguments.keyExists('params')) arguments = arguments.params;
    if (!isNumeric(arguments.get('maxrows'))) arguments.maxrows = -1;

    var sproc = new StoredProc(procedure: 'userlinks_search', datasource: datasource());
    sproc.addParam(cfsqltype: 'integer', value: arguments.get('ul_ulid'), null: !arguments.keyExists('ul_ulid'));
    sproc.addParam(cfsqltype: 'integer', value: arguments.get('ul_usid'), null: !arguments.keyExists('ul_usid'));
    sproc.addProcResult(name: 'qry', resultset: 1, maxrows: arguments.maxrows);

    return sproc.execute().getProcResultSets().qry;
  }
}
