component {
  // META CODE - DEFINES A PUBLIC FUNCTION FOR EACH BOOTSTRAP TYPE
  for (method in 'danger,dark,info,light,primary,secondary,success') {
    variables[method] = function(required string text, boolean closeable=true) {
      alert(text, GetFunctionCalledName(), closeable);
    }
  }

  public void function alert(required string text, string type='info', boolean closeable=true) {
    param session.flash = [];
    session.flash.append(arguments);
  }

  public void function clear() {
    session.flash = [];
  }

  public boolean function error(required string text, boolean closeable=true) {
    alert(text, 'danger', closeable);
    return false;
  }

  public boolean function information(required string text, boolean closeable=true) {
    alert(text, 'info', closeable);
    return false;
  }

  public boolean function warning(required string text, boolean closeable=true) {
    alert(text, 'warning', closeable);
    return false;
  }

  public boolean function isEmpty() {
    return messages().isEmpty();
  }

  public numeric function len() {
    return messages().len();
  }

  public array function messages() {
    param session.flash = [];
    return session.flash;
  }

  public struct function grouped() {
    var groups = {};
    for (var msg in sorted()) {
      groups[msg.type] = groups.get(msg.type) ?: [];
      groups[msg.type].append(msg);
    }
    return groups;
  }

  public array function sorted() {
    return messages().sort((a1,a2) => compare(a1.type, a2.type));
  }
}
