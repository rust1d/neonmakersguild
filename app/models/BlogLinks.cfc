component extends=BaseModel accessors=true {
  property name='bli_bliid'        type='numeric'  sqltype='integer'  primary_key;
  property name='bli_blog'         type='numeric'  sqltype='integer';
  property name='bli_type'         type='string'   sqltype='varchar';
  property name='bli_url'          type='string'   sqltype='varchar';
  property name='bli_title'        type='string'   sqltype='varchar';
  property name='bli_description'  type='string'   sqltype='varchar';

  belongs_to(name: 'UserBlog', class: 'Users', key: 'bli_blog', relation: 'us_usid');

  public query function search(struct params) {
    if (arguments.keyExists('params')) arguments = arguments.params;
    if (!isNumeric(arguments.get('maxrows'))) arguments.maxrows = -1;

    var sproc = new StoredProc(procedure: 'bloglinks_search', datasource: datasource());
    sproc.addParam(cfsqltype: 'integer', value: arguments.get('bli_bliid'), null: !arguments.keyExists('bli_bliid'));
    sproc.addParam(cfsqltype: 'integer', value: arguments.get('bli_blog'),  null: !arguments.keyExists('bli_blog'));
    sproc.addProcResult(name: 'qry', resultset: 1, maxrows: arguments.maxrows);

    return sproc.execute().getProcResultSets().qry;
  }

  public string function domain() {
    return isNull(variables.bli_url) ? '' : utility.getDomain(bli_url);
  }

  public boolean function isClass() {
    return ListLast(variables.bli_type ?: '', '/')=='class';
  }

  public boolean function isResource() {
    return ListFirst(variables.bli_type ?: '', '/')=='resource';
  }

  public boolean function isSupplier() {
    return ListLast(variables.bli_type ?: '', '/')=='supplier';
  }

  public boolean function isSocial() {
    return (variables.bli_type ?: '')=='social media';
  }

  public boolean function isWebsite() {
    return (variables.bli_type ?: '')=='website';
  }

  public string function social_type() {
    if (!isSocial()) return '';

    var dom = domain();
    if (dom.len()==0) return '';

    for (var type in social_types()) if (dom.contains(type)) return type;

    return '';
  }

  public array function social_types() {
    return listToArray('facebook,flickr,instagram,linkedin,pinterest,snapchat,tiktok,twitter,vimeo,youtube');
  }

  public string function icon_link(string size = '2x') {
    if (isNull(variables.bli_url)) return '';
    var type = social_type();
    var icon = type.len() ? 'fa-brands fa-#type#' : icons().get(bli_type ?: 'bookmark') ?: 'fa-regular fa-block-question';
    return '<a href="#bli_url#" target="_blank"><i class="fa-#size# #icon#"></i></a>';
  }

  public array function types() {
    if (bli_blog==1) return icons().keyArray().sort('text');

    return ['bookmark','social media','website'];
  }

  // PRIVATE

  private struct function icons() {
    return {
      'bookmark':           'fa-solid fa-square-arrow-up-right',
      'social media':       'fa-regular fa-sparkles',
      'website':            'fa-regular fa-globe',
      'resource/class':     'fa-solid fa-school',
      'resource/supplier':  'fa-solid fa-truck-field'
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
