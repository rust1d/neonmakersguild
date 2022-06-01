component extends=jSoup accessors=true {
  property name='ben_benid'         type='numeric'  sqltype='integer'    primary_key;
  property name='ben_blog'          type='numeric'  sqltype='integer';
  property name='ben_usid'          type='numeric'  sqltype='integer';
  property name='ben_posted'        type='date'     sqltype='timestamp';
  property name='ben_title'         type='string'   sqltype='varchar';
  property name='ben_alias'         type='string'   sqltype='varchar';
  property name='ben_image'         type='string'   sqltype='varchar';
  property name='ben_body'          type='string'   sqltype='varchar'    html;
  property name='ben_morebody'      type='string'   sqltype='varchar'    html;
  property name='ben_comments'      type='boolean'  sqltype='tinyint'    default='false';
  property name='ben_views'         type='numeric'  sqltype='integer'    default='0';
  property name='ben_released'      type='boolean'  sqltype='tinyint'    default='false';
  property name='ben_promoted'      type='date'     sqltype='timestamp';
  property name='ben_added'         type='date';
  property name='ben_dla'           type='date';
  property name='ben_blogname'      type='string';
  property name='ben_comment_cnt'   type='numeric';

  has_many(name: 'BlogComments',         class: 'BlogComments',           key: 'ben_benid',  relation: 'bco_benid');
  has_many(name: 'BlogEntryCategories',  class: 'BlogEntriesCategories',  key: 'ben_benid',  relation: 'bec_benid');
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
    sproc.addParam(cfsqltype: 'tinyint',   value: arguments.get('ben_promoted'), null: !arguments.keyExists('ben_promoted'));
    sproc.addParam(cfsqltype: 'integer',   value: arguments.get('bca_bcaid'),    null: !arguments.keyExists('bca_bcaid'));
    sproc.addParam(cfsqltype: 'varchar',   value: arguments.get('term'),         null: !arguments.keyExists('term'));
    sproc.addProcResult(name: 'qry', resultset: 1, maxrows: arguments.maxrows);

    return paged_search(sproc, arguments);
  }

  public array function category_links() {
    var links = [];
    for (var mCat in this.BlogEntryCategories()) {
      links.append("<a href='#mCat.seo_link()#'>#mCat.category()#</a>");
    }
    return links;
  }

  public string function post_date() {
    return isNull(variables.ben_posted) ? '' : utility.ordinalDate(ben_posted);
  }

  public string function posted() {
    return isNull(variables.ben_posted) ? '' : ben_posted.format('yyyy-mm-dd HH:nn');
  }

  public string function posted_date() {
    param variables.ben_posted = now();
    return ben_posted.format('yyyy-mm-dd');
  }

  public string function posted_time() {
    param variables.ben_posted = now();
    return ben_posted.format('HH:nn');
  }

  public string function seo_link() {
    if (new_record()) return 'page/404';

    param variables.ben_blogname = this.UserBlog().user();
    return '/post/#ben_blogname#/#ben_alias#';
  }

  public void function view() {
    if (new_record()) return;

    param variables.ben_views = 0;
    variables.ben_views++;

    queryExecute(
      'UPDATE blogentries SET ben_views=IFNULL(ben_views,0)+1 WHERE ben_benid=:pkid',
      { pkid: { value: variables.ben_benid, cfsqltype: 'integer' } }, { datasource: datasource() }
    );
  }

  // PRIVATE

  private void function post_load() {
    param variables.ben_posted = now();
  }

  private void function pre_save() {
    if (!isDate(variables.get('ben_posted'))) variables.ben_posted = now();
    if (len(variables.ben_alias)==0) variables.delete('ben_alias'); // defaults next line
    param variables.ben_alias = variables.ben_title;
    if (this.alias_changed()) {
      variables.ben_alias = utility.slug(ben_alias);
      // var qry = this.search(ben_alias: ben_alias);
      // if (qry.len() && qry.ben_benid != primary_key()) {
      //   errors().append('Entry alias #ben_alias# is in use.');
      // }
    }
  }
}
