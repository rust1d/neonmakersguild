component extends=BaseModel accessors=true {
  property name='bec_becid'     type='numeric'  sqltype='integer'  primary_key;
  property name='bec_benid'     type='numeric'  sqltype='integer';
  property name='bec_bcaid'     type='numeric'  sqltype='integer';
  property name='bec_category'  type='string';
  property name='bec_alias'     type='string';

  public query function search(struct params) {
    if (arguments.keyExists('params')) arguments = arguments.params;
    if (!isNumeric(arguments.get('maxrows'))) arguments.maxrows = -1;

    var sproc = new StoredProc(procedure: 'blogentriescategories_search', datasource: datasource());
    sproc.addParam(cfsqltype: 'integer', value: arguments.get('bec_becid'), null: !arguments.keyExists('bec_becid'));
    sproc.addParam(cfsqltype: 'integer', value: arguments.get('bec_benid'), null: !arguments.keyExists('bec_benid'));
    sproc.addProcResult(name: 'qry', resultset: 1, maxrows: arguments.maxrows);

    return sproc.execute().getProcResultSets().qry;
  }

  public string function seo_link() {
    return '/category/#bec_bcaid#/#bec_alias#';
  }
}
