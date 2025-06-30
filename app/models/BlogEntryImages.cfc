component extends=BaseModel accessors=true {
  property name='bei_beiid'     type='numeric'  sqltype='integer'  primary_key;
  property name='bei_benid'     type='numeric'  sqltype='integer';
  property name='bei_uiid'      type='numeric'  sqltype='integer';
  property name='bei_category'  type='string';
  property name='bei_alias'     type='string';
  property name='bei_blogname'  type='string';

  belongs_to(name: 'BlogEntry', class: 'BlogEntries',    key: 'bei_benid', relation: 'ben_benid');
  has_one(name: 'BlogCategory', class: 'BlogCategories', key: 'bei_bcaid', relation: 'bca_bcaid');

  public query function search(struct params) {
    if (arguments.keyExists('params')) arguments = arguments.params;
    if (!isNumeric(arguments.get('maxrows'))) arguments.maxrows = -1;

    var sproc = new StoredProc(procedure: 'blogentriescategories_search', datasource: datasource());
    sproc.addParam(cfsqltype: 'integer', value: arguments.get('bei_beiid'), null: !arguments.keyExists('bei_beiid'));
    sproc.addParam(cfsqltype: 'integer', value: arguments.get('bei_benid'), null: !arguments.keyExists('bei_benid'));
    sproc.addParam(cfsqltype: 'integer', value: arguments.get('bei_bcaid'), null: !arguments.keyExists('bei_bcaid'));
    sproc.addProcResult(name: 'qry', resultset: 1, maxrows: arguments.maxrows);
    return paged_search(sproc, arguments);
  }

  public string function seo_link() {
    if (new_record()) return 'page/404';

    param variables.bei_blogname = this.BlogEntry().UserBlog().user();
    param variables.bei_category = this.BlogCategory().category();
    param variables.bei_alias = this.BlogCategory().alias();

    return '/post/#bei_blogname#/category/#bei_alias#';
  }
}
