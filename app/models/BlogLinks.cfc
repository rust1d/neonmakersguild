component extends=BaseModel accessors=true {
  property name='bli_bliid'  type='numeric'  sqltype='integer'  primary_key;
  property name='bli_blog'   type='numeric'  sqltype='integer';
  property name='bli_url'    type='string'   sqltype='varchar';
  property name='bli_title'  type='string'   sqltype='varchar';
  property name='bli_type'   type='string'   sqltype='varchar';

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

  public boolean function isSocial() {
    return (variables.bli_type ?: '') == 'social media';
  }

  public string function social_type() {
    if (!isSocial()) return '';

    var dom = domain();
    if (dom.len()==0) return '';

    for (var type in new app.services.SocialIcons().types()) {
      if (dom.contains(type)) return type;
    }
    return '';
  }

  public string function social_link(string size = '2x') {
    var type = social_type();
    if (type.len()==0) return '';
    return '<a href="#bli_url#" target="_blank"><i class="fa-#size# fa-brands fa-#type#"></i></a>';
  }

  public array function types() {
    return [
      'bookmark',
      'social media',
      'website'
    ]
  }

  // PRIVATE

  private void function pre_save() {
    if (this.url_changed()) {
      if (bli_url.reMatch('^http*.').len()==0) bli_url = 'https://' & bli_url;
    }
  }
}
