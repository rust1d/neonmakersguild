component extends=BaseModel accessors=true {

  public any function document() {
    return variables._document = variables._document ?: new app.services.jSoup(html());
  }

  public string function html() { // ALL FIELDS IN MODEL WITH html IN PROPERTIES WILL BE JOINED.
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

  public string function preview(numeric chars=200, numeric words=0) {
    var txt = text();
    var wrds = [];
    if (arguments.words) {
      wrds = variables.words();
      if (wrds.len()<=arguments.words) return txt;
      wrds = utility.slice(wrds, arguments.words)
    } else {
      if (txt.len() < arguments.chars) return txt;
      wrds = txt.left(arguments.chars).listToArray(' ');
      wrds.pop(); // REMOVES LAST WORD, WHICH IS LIKELY CUT OFF
    }
    return wrds.toList(' ') & '&hellip;';
  }

  public string function text() {
    return trim(document().text());
  }

  public array function words() { // COUNT
    return document().words();
  }
}
