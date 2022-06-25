component extends=BaseModel accessors=true {
  property name='dt_dtid'   type='numeric'  sqltype='integer'  primary_key;
  property name='dt_docid'  type='numeric'  sqltype='integer';
  property name='dt_tagid'  type='numeric'  sqltype='integer';

  belongs_to(name: 'Document', class: 'Documents', key: 'dt_docid',  relation: 'doc_docid', preloaded: true); // PRELOADED MEANS _search RETURNS FULL RECORD SO THE RELATION CAN BE PRE-FILLED IN 1 QUERY
  belongs_to(name: 'Tag',     class: 'Tags',       key: 'dt_tagid', relation: 'tag_tagid',  preloaded: true);

  public query function search(struct params) {
    if (arguments.keyExists('params')) arguments = arguments.params;
    if (!isNumeric(arguments.get('maxrows'))) arguments.maxrows = -1;

    var sproc = new StoredProc(procedure: 'documenttags_search', datasource: datasource());
    sproc.addParam(cfsqltype: 'integer', value: arguments.get('dt_dtid'),  null: !arguments.keyExists('dt_dtid'));
    sproc.addParam(cfsqltype: 'integer', value: arguments.get('dt_docid'), null: !arguments.keyExists('dt_docid'));
    sproc.addParam(cfsqltype: 'integer', value: arguments.get('dt_tagid'), null: !arguments.keyExists('dt_tagid'));
    sproc.addProcResult(name: 'qry', resultset: 1, maxrows: arguments.maxrows);
    return paged_search(sproc, arguments);
  }
}
