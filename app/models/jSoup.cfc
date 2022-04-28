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
    if (text().len() < chars) return text();
    var data = text().left(chars).listToArray(' ');
    data.pop(); // REMOVES LAST WORD, WHICH IS LIKELY CUT OFF
    return data.toList(' ');
  }

  public string function text() {
    return document().text();
  }

  public array function words() { // COUNT
    return document().words();
  }
}
