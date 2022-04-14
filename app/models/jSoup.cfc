component extends=BaseModel accessors=true {

  public any function document() {
    return variables._document = variables._document ?: new app.services.jSoup(html());
  }

  public string function html() {
    var data = '';

    for (var field in GetMetaData(this).properties) {
      if (!field.keyExists('html')) continue;
      data = data.listAppend(variables[field.name] ?: '');
    }
    return data;
  }

  public array function images() {
    return document().images();
  }

  public string function preview(numeric chars=100) {
    if (html().len() < chars) return html();
    var data = text().left(chars).listToArray(' ');
    data.pop();
    return data.toList(' ');
  }

  public string function text() {
    return document().text();
  }

  public array function words() {
    return document().words();
  }
}