component extends=BaseModel accessors=true {
  property name='bec_becid'     type='numeric'  sqltype='integer'  primary_key;
  property name='bec_benid'     type='numeric'  sqltype='integer';
  property name='bec_bcaid'     type='numeric'  sqltype='integer';
  property name='bec_category'  type='string';
  property name='bec_alias'     type='string';
  property name='bec_blogname'  type='string';

  belongs_to(name: 'BlogEntry', class: 'BlogEntries',    key: 'bec_benid', relation: 'ben_benid');
  has_one(name: 'BlogCategory', class: 'BlogCategories', key: 'bec_bcaid', relation: 'bca_bcaid');

  public query function search(struct params) {
    if (arguments.keyExists('params')) arguments = arguments.params;
    if (!isNumeric(arguments.get('maxrows'))) arguments.maxrows = -1;

    var sproc = new StoredProc(procedure: 'blogentriescategories_search', datasource: datasource());
    sproc.addParam(cfsqltype: 'integer', value: arguments.get('bec_becid'), null: !arguments.keyExists('bec_becid'));
    sproc.addParam(cfsqltype: 'integer', value: arguments.get('bec_benid'), null: !arguments.keyExists('bec_benid'));
    sproc.addParam(cfsqltype: 'integer', value: arguments.get('bec_bcaid'), null: !arguments.keyExists('bec_bcaid'));
    sproc.addProcResult(name: 'qry', resultset: 1, maxrows: arguments.maxrows);

    return sproc.execute().getProcResultSets().qry;
  }

  public string function seo_link() {
    if (new_record()) return 'page/404';

    param variables.bec_blogname = this.BlogEntry().UserBlog().user();
    param variables.bec_category = this.BlogCategory().category();
    param variables.bec_alias = this.BlogCategory().alias();

    return '/post/#bec_blogname#/category/#bec_alias#';
  }
}
