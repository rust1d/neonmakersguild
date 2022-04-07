component extends=BaseModel accessors=true {
  property name='bre_breid'     type='numeric'  sqltype='integer'  primary_key;
  property name='bre_benid'     type='numeric'  sqltype='integer';
  property name='bre_relbenid'  type='numeric'  sqltype='integer';

  belongs_to(name: 'BlogEntry', class: 'BlogEntries',  key: 'bre_benid', relation: 'ben_benid');
  has_one(name: 'RelatedBlogEntry', class: 'BlogEntries',  key: 'bre_relbenid', relation: 'ben_benid');

  public query function search(struct params) {
    if (arguments.keyExists('params')) arguments = arguments.params;
    if (!isNumeric(arguments.get('maxrows'))) arguments.maxrows = -1;

    var sproc = new StoredProc(procedure: 'blogentriesrelated_search', datasource: datasource());
    sproc.addParam(cfsqltype: 'integer', value: arguments.get('bre_breid'),    null: !arguments.keyExists('bre_breid'));
    sproc.addParam(cfsqltype: 'integer', value: arguments.get('bre_benid'),    null: !arguments.keyExists('bre_benid'));
    sproc.addParam(cfsqltype: 'integer', value: arguments.get('bre_relbenid'), null: !arguments.keyExists('bre_relbenid'));
    sproc.addProcResult(name: 'qry', resultset: 1, maxrows: arguments.maxrows);

    return sproc.execute().getProcResultSets().qry;
  }
}
