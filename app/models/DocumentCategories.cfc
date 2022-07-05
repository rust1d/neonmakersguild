component extends=BaseModel accessors=true {
  property name='dc_dcid'   type='numeric'  sqltype='integer'  primary_key;
  property name='dc_docid'  type='numeric'  sqltype='integer';
  property name='dc_bcaid'  type='numeric'  sqltype='integer';

  belongs_to(name: 'Document', class: 'Documents', key: 'dc_docid', relation: 'doc_docid', preloaded: true);
  has_one(name: 'BlogCategory', class: 'BlogCategories', key: 'dc_bcaid', relation: 'bca_bcaid', preloaded: true);

  public query function search(struct params) {
    if (arguments.keyExists('params')) arguments = arguments.params;
    if (!isNumeric(arguments.get('maxrows'))) arguments.maxrows = -1;

    var sproc = new StoredProc(procedure: 'documentcategories_search', datasource: datasource());
    sproc.addParam(cfsqltype: 'integer', value: arguments.get('dc_dcid'),  null: !arguments.keyExists('dc_dcid'));
    sproc.addParam(cfsqltype: 'integer', value: arguments.get('dc_docid'), null: !arguments.keyExists('dc_docid'));
    sproc.addParam(cfsqltype: 'integer', value: arguments.get('dc_bcaid'), null: !arguments.keyExists('dc_bcaid'));
    sproc.addProcResult(name: 'qry', resultset: 1, maxrows: arguments.maxrows);
    return paged_search(sproc, arguments);
  }
}
