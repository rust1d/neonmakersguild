component accessors=true {
  property name='_site'          type='string' default='';

  public CurrentSite function init(string site) {
    variables._site = arguments.site ?: url.get('ref') ?: cookie.get('ref') ?: 'nmg';
    if (!listFindNoCase('nmg,admin', _site)) variables._site = 'nmg';
    if (valid()) set_cookie();
    return this;
  }

  public boolean function admin() {
    return isA('admin');
  }

  public boolean function isA(required string data) {
    return get_site() == data;
  }

  public string function path() {
    return get_site(); // CAN OVERRIDE IN CHILD
  }

  public Site function site() { // CHILD SITE
    if (isNull(variables._cur_site)) {
      variables._cur_site = new 'app.services.sites.#get_site()#'();
    }
    return variables._cur_site;
  }

  public boolean function set(string data = '') { // MANUAL SITE OVERRIDE
    variables._site = arguments.data;
    variables.delete('_cur_site');
    return valid();
  }

  public boolean function valid() {
    return FileExists(expandPath('/app/services/sites/#get_site()#.cfc'));
  }

  public any function onMissingMethod(required string missingMethodName, required struct missingMethodArguments) {
    return invoke(site(), missingMethodName, missingMethodArguments);
  }

  // PRIVATE

  private void function set_cookie() {
    cookie['ref'] = { value: get_site(), expires: dateConvert('local2utc', now().add('d', 1)) }
  }
}
