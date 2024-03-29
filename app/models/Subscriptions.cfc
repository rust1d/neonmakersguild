component extends=BaseModel accessors=true {
  property name='ss_ssid'   type='numeric'  sqltype='integer'    primary_key;
  property name='ss_usid'   type='numeric'  sqltype='integer';
  property name='ss_fkey'   type='numeric'  sqltype='integer';
  property name='ss_table'  type='string'   sqltype='varchar';
  property name='ss_added'  type='date';

  public boolean function alert(required numeric ss_fkey, required string ss_table, numeric ss_usid=0) {
    if (count(ss_usid: arguments.ss_usid, ss_fkey: arguments.ss_fkey, ss_table: arguments.ss_table)) return true;
    return new app.models.Subscriptions(arguments).safe_save();
  }

  public array function alerts() {
    var sproc = new StoredProc(procedure: 'subscriptions_alerts', datasource: datasource());
    sproc.addProcResult(name: 'qry', resultset: 1, maxrows: 200);
    return preserveNulls(sproc.execute().getProcResultSets().qry);
  }

  public numeric function delete_by_user(required numeric usid) {
    var sproc = new StoredProc(procedure: 'subscriptions_delete_user', datasource: datasource());
    sproc.addParam(cfsqltype: 'integer', value: arguments.usid);
    sproc.addProcResult(name: 'qry', resultset: 1);
    return sproc.execute().getProcResultSets().qry.delete_count;
  }

  public BaseModel function model() {
    return variables._model = variables._model ?: new 'app.models.#ss_table#'().find(ss_fkey);
  }

  public boolean function owner(required numeric usid) {
    return matches({ ss_usid: usid });
  }

  public query function search(struct params) {
    if (arguments.keyExists('params')) arguments = arguments.params;
    if (!isNumeric(arguments.get('maxrows'))) arguments.maxrows = -1;

    var sproc = new StoredProc(procedure: 'subscriptions_search', datasource: datasource());
    sproc.addParam(cfsqltype: 'integer', value: arguments.get('ss_ssid'),  null: !arguments.keyExists('ss_ssid'));
    sproc.addParam(cfsqltype: 'integer', value: arguments.get('ss_usid'),  null: !arguments.keyExists('ss_usid'));
    sproc.addParam(cfsqltype: 'integer', value: arguments.get('ss_fkey'),  null: !arguments.keyExists('ss_fkey'));
    sproc.addParam(cfsqltype: 'varchar', value: arguments.get('ss_table'), null: !arguments.keyExists('ss_table'));
    sproc.addProcResult(name: 'qry', resultset: 1, maxrows: arguments.maxrows);

    return sproc.execute().getProcResultSets().qry;
  }

  public boolean function subscribe() {
    if (persisted()) return true;
    if (count(ss_usid: ss_usid, ss_fkey: ss_fkey, ss_table: ss_table)) return true;
    logger(GetFunctionCalledName());
    return safe_save();
  }

  public boolean function unsubscribe() {
    if (new_record()) return true;
    if (destroy()) variables.delete('ss_ssid');
    logger(GetFunctionCalledName());
    return new_record();
  }

  // PRIVATE

  private void function logger(required string mode) {
    var path = ExpandPath('\') & 'tmp\subscriptions.txt';
    var data = toStruct();
    data.mode = arguments.mode;
    fileAppend(path, SerializeJson(data));
  }

  private void function pre_save() {
    if (isNull(variables.ss_usid)) throw('User is required.', 'validation_error');
    if (isNull(variables.ss_fkey)) throw('Key is required.', 'validation_error');
    if (isNull(variables.ss_table)) throw('Table is required.', 'validation_error');
  }
}
