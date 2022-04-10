component extends=BaseModel accessors=true {
  property name='bpc_bpcid'     type='numeric'  sqltype='integer'  primary_key;
  property name='bpc_bpaid'     type='numeric'  sqltype='integer';
  property name='bpc_bcaid'     type='numeric'  sqltype='integer';
  property name='bpc_category'  type='string';
  property name='bpc_alias'     type='string';
  property name='bpc_blogname'  type='string';

  belongs_to(name: 'BlogPage',  class: 'BlogPages',       key: 'bpc_bpaid', relation: 'bpa_bpaid');
  has_one(name: 'BlogCategory', class: 'BlogCategories',  key: 'bpc_bcaid', relation: 'bca_bcaid');

  public query function search(struct params) {
    if (arguments.keyExists('params')) arguments = arguments.params;
    if (!isNumeric(arguments.get('maxrows'))) arguments.maxrows = -1;

    var sproc = new StoredProc(procedure: 'blogpagescategories_search', datasource: datasource());
    sproc.addParam(cfsqltype: 'integer', value: arguments.get('bpc_bpcid'), null: !arguments.keyExists('bpc_bpcid'));
    sproc.addParam(cfsqltype: 'integer', value: arguments.get('bpc_bpaid'), null: !arguments.keyExists('bpc_bpaid'));
    sproc.addParam(cfsqltype: 'integer', value: arguments.get('bpc_bcaid'), null: !arguments.keyExists('bpc_bcaid'));
    sproc.addProcResult(name: 'qry', resultset: 1, maxrows: arguments.maxrows);

    return sproc.execute().getProcResultSets().qry;
  }

  public string function seo_link() {
    if (new_record()) return 'page/404';

    param variables.bpc_blogname = this.BlogPage().UserBlog().user();
    param variables.bpc_category = this.BlogCategory().category();
    param variables.bpc_alias = this.BlogCategory().alias();

    return '/page/#bpc_blogname#/category/#bpc_alias#';
  }
}
