component {
  public jsoup function init(required string data) {
    variables.document = createObject('java', 'org.jsoup.Jsoup').parse(data);
    variables.utility = application.utility;
    return this;
  }

  public array function images() {
    return variables._images = variables._images ?: document.body().select('img').map(img => img.attr('src'));
  }

  public string function preview(numeric chars=100) {
    if (text().len() < chars) return text();
    var data = text().left(chars).listToArray(' ');
    data.pop();
    return data.toList(' ');
  }

  public string function text() {
    return variables._text = variables._text ?: document.text();
  }

  public array function words() {
    return variables._words = variables._words ?: utility.slug(text()).listToArray('-');
  }
}
