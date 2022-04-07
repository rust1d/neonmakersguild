component extends=BaseModel accessors=true {
  property name='bca_bcaid'     type='numeric'  sqltype='integer'  primary_key;
  property name='bca_blog'      type='numeric'  sqltype='integer';
  property name='bca_category'  type='string'   sqltype='varchar';
  property name='bca_alias'     type='string'   sqltype='varchar';
  property name='bca_entrycnt'  type='numeric';

  public query function search(struct params) {
    if (arguments.keyExists('params')) arguments = arguments.params;
    if (!isNumeric(arguments.get('maxrows'))) arguments.maxrows = -1;

    var sproc = new StoredProc(procedure: 'blogcategories_search', datasource: datasource());
    sproc.addParam(cfsqltype: 'integer', value: arguments.get('bca_bcaid'),    null: !arguments.keyExists('bca_bcaid'));
    sproc.addParam(cfsqltype: 'integer', value: arguments.get('bca_blog'),     null: !arguments.keyExists('bca_blog'));
    sproc.addParam(cfsqltype: 'varchar', value: arguments.get('bca_category'), null: !arguments.keyExists('bca_category'));
    sproc.addParam(cfsqltype: 'varchar', value: arguments.get('bca_alias'),    null: !arguments.keyExists('bca_alias'));
    sproc.addProcResult(name: 'qry', resultset: 1, maxrows: arguments.maxrows);

    return sproc.execute().getProcResultSets().qry;
  }
}
