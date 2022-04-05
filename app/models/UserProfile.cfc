component extends=BaseModel accessors=true {
  property name='up_upid'       type='numeric'  sqltype='integer'    primary_key;
  property name='up_usid'       type='numeric'  sqltype='integer';
  property name='up_firstname'  type='string'   sqltype='varchar';
  property name='up_lastname'   type='string'   sqltype='varchar';
  property name='up_bio'        type='string'   sqltype='varchar';
  property name='up_location'   type='string'   sqltype='varchar';
  property name='up_dla'        type='date';

  belongs_to(class: 'Users',  key: 'up_usid', relation: 'us_usid');

  public query function search(struct params) {
    if (arguments.keyExists('params')) arguments = arguments.params;
    if (!isNumeric(arguments.get('maxrows'))) arguments.maxrows = -1;

    var sproc = new StoredProc(procedure: 'userprofile_search', datasource: datasource());
    sproc.addParam(cfsqltype: 'integer', value: arguments.get('up_upid'), null: !arguments.keyExists('up_upid'));
    sproc.addParam(cfsqltype: 'integer', value: arguments.get('up_usid'), null: !arguments.keyExists('up_usid'));
    sproc.addProcResult(name: 'qry', resultset: 1, maxrows: arguments.maxrows);

    return sproc.execute().getProcResultSets().qry;
  }

  public string function name() {
    return trim(up_firstname & ' ' & up_lastname);
  }
}
