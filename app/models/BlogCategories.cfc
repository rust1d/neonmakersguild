component extends=BaseModel accessors=true {
  property name='bca_bcaid'     type='numeric'  sqltype='integer'  primary_key;
  property name='bca_blog'      type='numeric'  sqltype='integer';
  property name='bca_category'  type='string'   sqltype='varchar';
  property name='bca_alias'     type='string'   sqltype='varchar';
  property name='bca_entrycnt'  type='numeric';
  property name='bca_blogname'  type='string';

  belongs_to(name: 'UserBlog',           class: 'Users',                key: 'bca_blog',   relation: 'us_usid');

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

  public array function save_categories(required numeric blog, required string data) { // ACCEPTS CSV OF EXISTING IDS/NEW DATA AND RETURNS LIST OF IDS
    var bca_ids = [];
    for (var val in DeserializeJSON('[#data#]')) { // USE DESERIALIZE SINCE THE LIST COULD HAVE QUOTED STRINGS WITH DELIMITERS INSIDE
      var params = { bca_blog: blog }
      if (isNumeric(val)) {
        params.bca_bcaid = val;
      } else {
        params.bca_category = val;
      }
      var qry = search(params);
      if (qry.len()) {
        bca_ids.append(qry.bca_bcaid);
      } else {
        var mdl = new app.models.BlogCategories(bca_category: bca, bca_blog: blog);
        if (mdl.safe_save()) bca_ids.append(mdl.bcaid());
      }
    }
    return bca_ids;
  }

  private void function pre_save() {
    if (len(variables?.bca_alias)==0) variables.delete('bca_alias'); // defaults next line
    param variables.bca_alias = variables.bca_category;
    if (this.alias_changed()) {
      variables.bca_alias = utility.slug(bca_alias);
      var qry = this.search(bca_blog: bca_blog, bca_alias: bca_alias);
      if (qry.len() && qry.bca_bcaid != primary_key()) {
        errors().append('Category alias #bca_alias# is in use.');
      }
    }
  }

  public string function seo_link(required string root) {
    if (new_record()) return 'page/404';

    param variables.bca_blogname = this.UserBlog().user();

    return '/#root#/#bca_blogname#/category/#bca_alias#';
  }
}
