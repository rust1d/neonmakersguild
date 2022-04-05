component extends=Site accessors=true {
  public string function title() {
    return application.settings.title & ' Admin';
  }
}
