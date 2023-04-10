component accessors=true {
  property name='site'         type='string';
  property name='default_site' type='string'  default='site';
  property name='views_path'   type='string'  default='app/views/';
  property name='views_map'    type='string'  default='/app/views/';
  property name='history'      type='array';
  property name='_template'    type='string';

  public Router function init(string homepage='home', string site='') {
    variables.homepage = arguments.homepage;
    variables.site = arguments.site;
    variables._template = template_from_url();
    variables.history = [];

    return this;
  }

  public numeric function decode(string key='id', struct data=url) {
    if (data.keyExists(key)) return application.utility.decode(data[key]);
    return 0;
  }

  public numeric function decode_form(string key='id') {
    try {
      if (form.keyExists(key)) {
        var data = form[key].listToArray('&').map(v => v.listToArray('=')).reduce((h,v)=> h.append({'#v[1]#':v[2]}), {});
        return decode(key, data);
      }
    } catch (any err) {}
    return 0;
  }

  public string function encode() {
    var keys = arguments.keyList();
    var rtn = [];
    for (var key in keys) {
      var data = arguments[key];
      var enc = application.utility.encode(data);
      rtn.append('#key#=#enc#');
    }
    return rtn.toList('&');
  }

  public void function go(required string dest) {
    location(dest, false);
  }

  public string function href(string page='') {
    var path = '';
    if (page.trim().len()) path = '/?p=' & page.trim();

    arguments.delete('page');
    var qry = [];
    for (var key in arguments.keyList()) qry.append('#key#=#arguments[key]#');
    if (qry.len()) path &= (path.len() ? '&' : '?') & qry.toList('&');

    return application.urls.root & path;
  }

  public string function hrefenc(string page) {
    var data = href(arguments.page ?: template_from_url());
    arguments.delete('page');
    if (arguments.isEmpty()) return data;
    return data & '&' & encode(argumentcollection: arguments);
  }

  public void function include(string partial, struct data={}) {
    var is_content = isNull(arguments.partial);
    var runonce = isNull(arguments.partial); // ONLY A PARTIAL SHOULD RUN MORE THAN ONCE
    param arguments.partial = template();
    include_global_scripts();
    include_view_scripts(partial);
    var locals_stack = variables.locals ?: {}; // stash current locals, if any
    variables.locals = data; // make data available to current template

    include_template(partial, runonce);
    variables.locals = locals_stack; // pop locals stack
  }

  public boolean function included(required string partial) {
    if (history.isEmpty()) return false;
    return history.find(template_path(partial));
  }

  public struct function last() {
    if (history.isEmpty()) return {};

    var data = {};
    data.filename = history.first();
    data.page = getFileFromPath(data.filename).listFirst('.');
    data.path = getDirectoryFromPath(data.filename);
    data.section = data.path.listLast('/');

    return data;
  }

  public void function redirenc(string page='') { // RETURNS TO HOMEPAGE IF NONE PASSED
    location(hrefenc(argumentcollection: arguments), false);
  }

  public void function redirect(string page='') { // RETURNS TO HOMEPAGE IF NONE PASSED
    if (template_not(page)) location(href(argumentcollection: arguments), false);
  }

  public void function redirect_if(required boolean condition, required string page) {
    if (condition) redirect(page);
  }

  public void function redirect_unless(required boolean condition, required string page) {
    if (!condition) redirect(page);
  }

  public void function reload() {
    router.go(router.url());
  }

  public string function slug() {
    return template().rereplace('[/_]','-','all');
  }

  public string function template() {
    return variables._template;
  }

  public boolean function template_exists(required string partial, boolean shared = false) {
    return fileExists(physical_path(partial, shared));
  }

  public boolean function template_is(required string data) {
    return data == template() ? true : false;
  }

  public boolean function template_not(required string data) {
    return !template_is(data);
  }

  public string function url() {
    var data = cgi.script_name;
    if (cgi.query_string.len()) data = data.listAppend(cgi.query_string, '?');
    return data;
  }

  public string function url_page() {
    return template().listLast('/');
  }

  // PRIVATE

  private string function clean(required string data) {
    return data.lcase().trim().replace('\', '/', 'all');
  }

  private void function include_global_scripts() {
    var filename = '/_global.cfm';
    if (not_included(filename)) {
      history.prepend(filename);
      include filename runonce = true;
    }
  }

  private boolean function include_layout(required string partial) {
    if (application.utility.isAjax()) return false;
    var parts = getDirectoryFromPath(partial).listToArray('/');
    parts.append('_layout');
    var filename = parts.toList('/');

    if (!template_exists(filename)) return false;

    filename = template_path(filename);
    history.prepend(filename);
    include filename runonce = true;
    return true;
  }

  private void function include_view_scripts(required string partial) {
    if (!template_exists(partial)) return;
    // INCLUDE ALL THE _include.cfm SCRIPT FILES IN THE PATH LEADING TO THE TEMPLATE
    var parts = getDirectoryFromPath(partial).listToArray('/').prepend('');
    var path = '';
    var filename = '';

    for (var part in parts) {
      path = path.listAppend(part, '/');
      if (path!='/') path &= '/';
      if (template_exists(path & '_include')) {
        filename = template_path(path & '_include');
        if (not_included(filename)) {
          history.prepend(filename);
          include filename runonce = true;
        }
      }
    }
  }

  private void function include_template(required string partial, required boolean once) {
    var shared = false;
    if (!template_exists(partial)) { // IF NOT ON CURRENT SITE
      shared = template_exists(partial, true); // CHECK THE DEFAULT SITE
      if (!shared) {
        writeoutput('<hr>#partial#<hr>');
        return; // STILL NOT FOUND JUST BAIL
      }
    }

    var filename = template_path(partial, shared);

    if (once && history.find(filename)) {
      history.prepend(filename & ' (skip)');
    } else {
      history.prepend(filename);
      include filename runonce = once;
    }
  }

  private boolean function not_included(required string filename) {
    return history.find(filename) == 0;
  }

  private string function physical_path(required string partial, boolean shared = false) {
    var path = shared ? default_site : site;
    return clean(application.paths.root & views_path & path & '/' & partial & '.cfm');
  }

  private string function template_from_url() {
    param url.p = variables.homepage;
    if (url.p.trim().isEmpty()) url.p = variables.homepage;
    url.p = url.p.reReplace('[^0-9A-Za-z&-=_]', '', 'all');

    return clean(url.p);
  }

  private string function template_path(required string partial, boolean shared = false) {
    var path = shared ? default_site : site;
    path = views_map & path & '/' & partial & '.cfm';
    return '/' & listToArray(path, '/').toList('/');
  }
}
