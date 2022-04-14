component extends=jSoup accessors=true {
  property name='ben_benid'          type='numeric'  sqltype='integer'    primary_key;
  property name='ben_blog'           type='numeric'  sqltype='integer';
  property name='ben_usid'           type='numeric'  sqltype='integer';
  property name='ben_title'          type='string'   sqltype='varchar';
  property name='ben_body'           type='string'   sqltype='varchar'    html;
  property name='ben_posted'         type='date'     sqltype='timestamp';
  property name='ben_morebody'       type='string'   sqltype='varchar'    html;
  property name='ben_alias'          type='string'   sqltype='varchar';
  property name='ben_allowcomments'  type='boolean'  sqltype='tinyint'    default='0';
  property name='ben_attachment'     type='string'   sqltype='varchar';
  property name='ben_filesize'       type='numeric'  sqltype='integer';
  property name='ben_mimetype'       type='string'   sqltype='varchar';
  property name='ben_views'          type='numeric'  sqltype='integer';
  property name='ben_released'       type='boolean'  sqltype='tinyint'    default='0';
  property name='ben_mailed'         type='numeric'  sqltype='tinyint';
  property name='ben_blogname'       type='string';

  has_many(name: 'BlogEntryCategories',  class: 'BlogEntriesCategories',  key: 'ben_benid',  relation: 'bec_benid');
  has_many(name: 'RelatedBlogEntries',   class: 'BlogEntriesRelated',     key: 'ben_benid',  relation: 'ber_benid');
  belongs_to(name: 'User',               class: 'Users',                  key: 'ben_usid',   relation: 'us_usid');
  belongs_to(name: 'UserBlog',           class: 'Users',                  key: 'ben_blog',   relation: 'us_usid');

  public query function search(struct params) {
    if (arguments.keyExists('params')) arguments = arguments.params;
    if (!isNumeric(arguments.get('maxrows'))) arguments.maxrows = -1;
    var sproc = new StoredProc(procedure: 'blogentries_search', datasource: datasource());
    sproc.addParam(cfsqltype: 'integer',   value: arguments.get('ben_benid'),    null: !arguments.keyExists('ben_benid'));
    sproc.addParam(cfsqltype: 'integer',   value: arguments.get('ben_blog'),     null: !arguments.keyExists('ben_blog'));
    sproc.addParam(cfsqltype: 'integer',   value: arguments.get('ben_usid'),     null: !arguments.keyExists('ben_usid'));
    sproc.addParam(cfsqltype: 'varchar',   value: arguments.get('ben_title'),    null: !arguments.keyExists('ben_title'));
    sproc.addParam(cfsqltype: 'timestamp', value: arguments.get('ben_posted'),   null: !arguments.keyExists('ben_posted'));
    sproc.addParam(cfsqltype: 'varchar',   value: arguments.get('ben_alias'),    null: !arguments.keyExists('ben_alias'));
    sproc.addParam(cfsqltype: 'tinyint',   value: arguments.get('ben_released'), null: !arguments.keyExists('ben_released'));
    sproc.addParam(cfsqltype: 'integer',   value: arguments.get('bca_bcaid'),    null: !arguments.keyExists('bca_bcaid'));
    sproc.addProcResult(name: 'qry', resultset: 1, maxrows: arguments.maxrows);

    return sproc.execute().getProcResultSets().qry;
  }

  public array function category_links() {
    var links = [];
    for (var mCat in this.BlogEntryCategories()) {
      links.append("<a href='#mCat.seo_link()#'>#mCat.category()#</a>");
    }
    return links;
  }

  public string function posted() {
    return isNull(variables.ben_posted) ? '' : ben_posted.format('yyyy-mm-dd HH:nn');
  }

  public string function seo_link() {
    if (new_record()) return 'page/404';

    param variables.ben_blogname = this.UserBlog().user();
    return '/post/#ben_blogname#/#ben_alias#';
  }

  // PRIVATE

  private void function pre_save() {
    if (len(variables.ben_alias)==0) variables.delete('ben_alias'); // defaults next line
    param variables.ben_alias = variables.ben_title;
    if (this.alias_changed()) {
      variables.ben_alias = utility.slug(ben_alias);
      var qry = this.search(ben_alias: ben_alias);
      if (qry.len() && qry.ben_benid != primary_key()) {
        errors().append('Entry alias #ben_alias# is in use.');
      }
    }
  }
}
