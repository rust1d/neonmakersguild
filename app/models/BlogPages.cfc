component extends=jSoup accessors=true {
  property name='bpa_bpaid'       type='numeric'  sqltype='integer'  primary_key;
  property name='bpa_blog'        type='numeric'  sqltype='integer';
  property name='bpa_title'       type='string'   sqltype='varchar';
  property name='bpa_alias'       type='string'   sqltype='varchar';
  property name='bpa_body'        type='string'   sqltype='varchar'  html;
  property name='bpa_standalone'  type='numeric'  sqltype='tinyint'  default='0';
  property name='bpa_blogname'    type='string';

  has_many(name: 'BlogPagesCategories',  class: 'BlogPagesCategories',  key: 'bpa_bpaid',  relation: 'bpc_bpaid');
  belongs_to(name: 'UserBlog',           class: 'Users',                key: 'bpa_blog',   relation: 'us_usid');

  public string function body_cdn() {
    return utility.body_cdn(variables.bpa_body ?: '');
  }

  public query function search(struct params) {
    if (arguments.keyExists('params')) arguments = arguments.params;
    if (!isNumeric(arguments.get('maxrows'))) arguments.maxrows = -1;

    var sproc = new StoredProc(procedure: 'blogpages_search', datasource: datasource());
    sproc.addParam(cfsqltype: 'integer', value: arguments.get('bpa_bpaid'), null: !arguments.keyExists('bpa_bpaid'));
    sproc.addParam(cfsqltype: 'integer', value: arguments.get('bpa_blog'),  null: !arguments.keyExists('bpa_blog'));
    sproc.addParam(cfsqltype: 'varchar', value: arguments.get('bpa_title'), null: !arguments.keyExists('bpa_title'));
    sproc.addParam(cfsqltype: 'varchar', value: arguments.get('bpa_alias'), null: !arguments.keyExists('bpa_alias'));
    sproc.addProcResult(name: 'qry', resultset: 1, maxrows: arguments.maxrows);

    return sproc.execute().getProcResultSets().qry;
  }

  public array function category_links() {
    var links = [];
    for (var mCat in this.BlogPagesCategories()) {
      links.append("<a href='#mCat.seo_link()#'>#mCat.category()#</a>");
    }
    return links;
  }

  public string function seo_link() {
    if (new_record()) return 'page/404';

    param variables.bpa_blogname = this.UserBlog().user();
    return '/page/#bpa_blogname#/#bpa_alias#';
  }

  // PRIVATE

  private void function post_load() {
    if (!isNull(variables.bpa_body)) variables.bpa_body = utility.body_nocdn(variables.bpa_body);
  }

  private void function pre_save() {
    if (len(variables.bpa_alias)==0) variables.delete('bpa_alias'); // defaults next line
    param variables.bpa_alias = variables.bpa_title;
    if (this.alias_changed()) {
      variables.bpa_alias = utility.slug(bpa_alias);
      var qry = this.search(bpa_alias: bpa_alias);
      if (qry.len() && qry.bpa_bpaid != primary_key()) {
        errors().append('Page alias #bpa_alias# is in use.');
      }
    }
  }
}
