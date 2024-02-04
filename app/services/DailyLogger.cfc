component accessors=true {
  property name='_logger'   type='any';
  property name='_type'     type='string';
  property name='_filename' type='string';

  public DailyLogger function init(required string type) {
    set_type(arguments.type);

    return this;
  }

  public void function close() {
    if (isNull(get_logger())) return;

    fileClose(get_logger());
    variables.delete('logger');
  }

  public void function log(required string msg) {
    if (isNull(get_logger())) open();
    var stamp = now().dateTimeFormat('yyyymmdd_HHnnss');

    FileWriteLine(get_logger(), stamp & ' ' & msg);
    close();
  }

  public void function open() {
    set_filename(log_filename());
    ensure_local_paths();
    close();
    var new_log = !fileExists(log_filename());
    set_logger(FileOpen(log_filename(), 'append'));
  }

  // PRIVATE

  private void function ensure_local_paths() {
    if (!directoryExists(local_path())) directoryCreate(local_path());
  }

  private string function local_path() {
    return ExpandPath('\') & 'tmp\dailylogs\';
  }

  private string function log_filename() {
    var ts = now().dateTimeFormat('yyyymmdd');
    return local_path() & get_type() & '_' & ts & '.txt';
  }
}
