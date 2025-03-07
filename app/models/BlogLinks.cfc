component extends=BaseModel accessors=true {
  property name='bli_bliid'        type='numeric'  sqltype='integer'  primary_key;
  property name='bli_blog'         type='numeric'  sqltype='integer';
  property name='bli_type'         type='string'   sqltype='varchar';
  property name='bli_url'          type='string'   sqltype='varchar';
  property name='bli_title'        type='string'   sqltype='varchar';
  property name='bli_description'  type='string'   sqltype='varchar';
  property name='bli_clicks'       type='numeric'  sqltype='integer';
  property name='bli_dla'          type='date';

  belongs_to(name: 'UserBlog', class: 'Users', key: 'bli_blog', relation: 'us_usid');

  public query function search(struct params) {
    if (arguments.keyExists('params')) arguments = arguments.params;
    if (!isNumeric(arguments.get('maxrows'))) arguments.maxrows = -1;

    var sproc = new StoredProc(procedure: 'bloglinks_search', datasource: datasource());
    sproc.addParam(cfsqltype: 'integer', value: arguments.get('bli_bliid'), null: !arguments.keyExists('bli_bliid'));
    sproc.addParam(cfsqltype: 'integer', value: arguments.get('bli_blog'),  null: !arguments.keyExists('bli_blog'));
    sproc.addParam(cfsqltype: 'varchar', value: arguments.get('bli_type'),  null: !arguments.keyExists('bli_type'));
    sproc.addParam(cfsqltype: 'varchar', value: arguments.get('term'),      null: !arguments.keyExists('term'));
    sproc.addProcResult(name: 'qry', resultset: 1, maxrows: arguments.maxrows);

    return paged_search(sproc, arguments);
  }

  public string function datadash() {
    if (new_record()) return '';
    return serializeJSON({ 'blog': bli_blog, 'pkid': bli_bliid });
  }

  public string function domain() {
    return isNull(variables.bli_url) ? '' : utility.getDomain(bli_url);
  }

  public string function icon_link(string size = '2x') {
    if (isNull(variables.bli_url)) return '';
    return "<a href='#bli_url#' title='#bli_title#' data-link='#datadash()#' target='_blank'>#icon(size)#</a>";
  }

  public string function icon(string size = '2x') {
    if (isNull(variables.bli_url)) return '';
    var type = social_type();
    var icon = type.len() ? 'fa-brands fa-#type#' : icons().get(bli_type ?: 'bookmark') ?: 'fa-solid fa-block-question';
    return "<i class='fa-#size# #icon#'></i>";
  }

  public boolean function isBookmark() {
    return (variables.bli_type ?: '')=='bookmark';
  }

  public boolean function isClass() {
    return (variables.bli_type ?: '')=='resources-classes';
  }

  public boolean function isResource() {
    return ListFirst(variables.bli_type ?: '', '-')=='resource';
  }

  public boolean function isSupplier() {
    return (variables.bli_type ?: '')=='resources-suppliers';
  }

  public boolean function isSocial() {
    return (variables.bli_type ?: '')=='social media';
  }

  public boolean function isWebsite() {
    return (variables.bli_type ?: '')=='website';
  }

  public boolean function recent() {
    return bli_dla.add('m', 1) > now();
  }

  public string function social_type() {
    if (!isSocial()) return '';

    var dom = domain();
    if (dom.len()==0) return '';

    for (var type in social_types()) if (dom.contains(type)) return type;

    return '';
  }

  public array function social_types() {
    return listToArray('bluesky,facebook,flickr,instagram,linkedin,pinterest,snapchat,tiktok,twitter,threads,vimeo,youtube');
  }

  public array function types() {
    if (bli_blog==1) return ['bookmark','social media','resources-classes','resources-other','resources-suppliers'];

    return ['bookmark','social media','website'];
  }

  // PRIVATE

  private struct function icons() {
    return {
      'bookmark':            'fa-solid fa-fw fa-square-arrow-up-right',
      'social media':        'fa-solid fa-thumbs-up',
      'website':             'fa-solid fa-globe',
      'resources-classes':   'fa-solid fa-fw fa-school',
      'resources-other':     'fa-solid fa-fw fa-link',
      'resources-suppliers': 'fa-solid fa-fw fa-truck-field'
    }
  }

  private void function post_load() {
    if (!isNull(variables.bli_url)) variables.bli_url = utility.url_add_protocol(bli_url);
  }

  private void function pre_save() {
    if (this.url_changed()) {
      variables.bli_url = utility.url_add_protocol(bli_url);
    }
  }
}
