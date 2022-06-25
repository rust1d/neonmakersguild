component extends=BaseModel accessors=true {
  property name='tag_tagid'  type='numeric'  sqltype='integer'  primary_key;
  property name='tag_blog'   type='numeric'  sqltype='integer';
  property name='tag_tag'    type='string'   sqltype='varchar';

  public query function search(struct params) {
    if (arguments.keyExists('params')) arguments = arguments.params;
    if (!isNumeric(arguments.get('maxrows'))) arguments.maxrows = -1;
  
    var sproc = new StoredProc(procedure: 'tags_search', datasource: datasource());
    sproc.addParam(cfsqltype: 'integer', value: arguments.get('tag_tagid'),  null: !arguments.keyExists('tag_tagid'));
    sproc.addParam(cfsqltype: 'varchar', value: arguments.get('tag_tag'),    null: !arguments.keyExists('tag_tag'));
    sproc.addParam(cfsqltype: 'varchar', value: arguments.get('tag_paging'), null: !arguments.keyExists('tag_paging'));
    sproc.addProcResult(name: 'qry', resultset: 1, maxrows: arguments.maxrows);
  
    return sproc.execute().getProcResultSets().qry;
  }
}
