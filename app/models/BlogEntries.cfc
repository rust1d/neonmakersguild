component extends=jSoup accessors=true {
  property name='ben_benid'         type='numeric'  sqltype='integer'    primary_key;
  property name='ben_blog'          type='numeric'  sqltype='integer';
  property name='ben_usid'          type='numeric'  sqltype='integer';
  property name='ben_posted'        type='date'     sqltype='timestamp';
  property name='ben_title'         type='string'   sqltype='varchar';
  property name='ben_alias'         type='string'   sqltype='varchar'    default='';
  property name='ben_image'         type='string'   sqltype='varchar';
  property name='ben_body'          type='string'   sqltype='varchar'    html;
  property name='ben_morebody'      type='string'   sqltype='varchar'    default='';
  property name='ben_comments'      type='boolean'  sqltype='tinyint'    default='false';
  property name='ben_views'         type='numeric'  sqltype='integer'    default='0';
  property name='ben_released'      type='boolean'  sqltype='tinyint'    default='false';
  property name='ben_promoted'      type='date'     sqltype='timestamp';
  property name='ben_added'         type='date';
  property name='ben_dla'           type='date';
  property name='ben_blogname'      type='string';
  property name='ben_comment_cnt'   type='numeric';
  property name='ben_image_cnt'     type='numeric';
  property name='ben_beiids'        type='array';

  has_many(name: 'BlogComments',         class: 'BlogComments',         key: 'ben_benid',  relation: 'bco_benid', where: { bco_beiid: 0 });
  has_many(name: 'BlogEntryImages',      class: 'BlogEntryImages',      key: 'ben_benid',  relation: 'bei_benid');
  has_many_through(class: 'UserImages',  through: 'BlogEntryImages');
  has_many(name: 'BlogEntryCategories',  class: 'BlogEntryCategories',  key: 'ben_benid',  relation: 'bec_benid');
  belongs_to(name: 'User',               class: 'Users',                key: 'ben_usid',   relation: 'us_usid');
  belongs_to(name: 'UserBlog',           class: 'Users',                key: 'ben_blog',   relation: 'us_usid');

  public array function category_links() {
    var links = [];
    for (var mCat in this.BlogEntryCategories()) {
      links.append("<a href='#mCat.seo_link()#'>#mCat.category()#</a>");
    }
    return links;
  }

  public string function image_url() {
    return application.urls.cdn & ben_image;
  }

  public boolean function is_promoted() {
    return isDate(variables.ben_promoted ?: '');
  }

  public boolean function owned_by(required BaseModel obj) {
    return variables.ben_blog>1 && obj.usid()==variables.ben_usid;
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

  public string function promoted() {
    return isNull(variables.ben_promoted) ? '' : ben_promoted.format('yyyy-mm-dd HH:nn');
  }

  public boolean function promotable() {
    return persisted() && ben_blog!=1;
  }

  public boolean function repost() {
    if (persisted()) return false;
    var qry = search(ben_usid: variables.ben_usid, maxrows: 1)
    if (qry.len()==0) return false;
    var twice = now().diff('n', qry.ben_added) < 1 && qry.ben_title == variables.ben_title;
    if (twice) load_db(qry);
    return twice;
  }


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

  public array function stream(struct params) {
    if (arguments.keyExists('params')) arguments = arguments.params;
    if (!isNumeric(arguments.get('maxrows'))) arguments.maxrows = -1;
    var sproc = new StoredProc(procedure: 'blogentries_stream', datasource: datasource(), cachedWithin: CreateTimeSpan(0,0,1,0));
    sproc.addParam(cfsqltype: 'integer',   value: arguments.get('days'),  null: !arguments.keyExists('days'));
    sproc.addParam(cfsqltype: 'integer',   value: arguments.get('count'), null: !arguments.keyExists('count'));
    sproc.addParam(cfsqltype: 'varchar',   value: arguments.get('term'),  null: !arguments.keyExists('term'));
    sproc.addProcResult(name: 'qry', resultset: 1, maxrows: arguments.maxrows);
    return this.wrap(paged_search(sproc, arguments));
  }

  public string function seo_link() {
    if (new_record()) return 'page/404';

    param variables.ben_blogname = this.UserBlog().user();
    return '/post/#ben_blogname#/#ben_alias#';
  }

  public string function summary() {
    if (variables.ben_morebody.len()) return variables.ben_morebody;
    return preview(words: 50);
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
    if (!isNull(variables.ben_morebody)) variables.ben_morebody = utility.body_nocdn(variables.ben_morebody);
    if (!isNull(variables.ben_image)) variables.ben_image = utility.body_nocdn(variables.ben_image);
  }

  private void function pre_load(required struct data) {
    variables.ben_beiids = [];
    if (data.keyExists('ben_beiids')) {
      variables.ben_beiids = data.ben_beiids.listToArray();
      variables.ben_image_cnt = variables.ben_beiids.len();
      data.delete('ben_beiids');
    }
  }

  private void function pre_save() {
    if (!isDate(variables.get('ben_posted'))) variables.ben_posted = now();
    if (len(variables.ben_alias)==0) variables.delete('ben_alias'); // defaults next line
    param variables.ben_alias = variables.ben_title;
    if (this.alias_changed()) {
      variables.ben_alias = utility.slug(ben_alias);
    }
    variables.ben_morebody = summary();
  }
}
