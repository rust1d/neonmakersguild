component accessors=true {
  public string function mailto_site() {
    return '<a href="mailto:#site_email()#">#site_email()#</a>';
  }

  public string function theme() {
    return 'light';
  }

  public string function site_email() {
    return application.email.support;
  }

  public string function title() {
    return application.settings.title;
  }
}
