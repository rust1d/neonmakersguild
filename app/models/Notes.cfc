component extends=BaseModel accessors=true {
  property name='no_noid'    type='numeric'  sqltype='integer'    primary_key;
  property name='no_usid'    type='numeric'  sqltype='integer';
  property name='no_note'    type='string'   sqltype='varchar';
  property name='no_poster'  type='string'   sqltype='varchar';
  property name='no_added'   type='date';
  property name='no_dla'     type='date';

  has_one(name: 'User',  class: 'Users',  key: 'no_usid',  relation: 'us_usid');

  public string function action() {
    if (!system()) return '';
    return note_data()?.action ?: 'MISSING';
  }

  public numeric function age_in_days() {
    return utility.age_in_days(variables.no_dla ?: now());
  }

  public struct function note_data(struct params) {
    param variables._note_data = {};
    if (arguments.keyExists('params')) variables._note_data = arguments.params;
    return variables._note_data;
  }

  public string function note() {
    if (!system()) return variables.no_note ?: '';
    return note_data().get('note') ?: action();
  }

  public query function search(struct params) {
    if (arguments.keyExists('params')) arguments = arguments.params;
    if (!isNumeric(arguments.get('maxrows'))) arguments.maxrows = -1;

    var sproc = new StoredProc(procedure: 'notes_search', datasource: datasource());
    sproc.addParam(cfsqltype: 'integer', value: arguments.get('no_noid'), null: !arguments.keyExists('no_noid'));
    sproc.addParam(cfsqltype: 'integer', value: arguments.get('no_usid'), null: !arguments.keyExists('no_usid'));
    sproc.addProcResult(name: 'qry', resultset: 1, maxrows: arguments.maxrows);

    return sproc.execute().getProcResultSets().qry;
  }

  public boolean function system() {
    if (isNull(variables.no_poster)) return false;
    return variables.no_poster == 'SYSTEM';
  }

  public Notes function system_action(required string action, required string note) {
    variables.no_poster = 'SYSTEM';
    if (session.user.loggedIn()) arguments.note &= ' by ' & session.user.user();
    note_data({ action: action, note: note, admin: session.user.user() });
    return this;
  }

  //

  private void function post_load() {
    if (system()) {
      try {
        variables._note_data = deserializeJSON(variables.no_note);
      } catch (any err) {}
      param variables._note_data = {};
    }
  }

  private void function pre_insert() {
    param variables.no_poster = session.user.user() ?: 'SYSTEM';
  }

  private void function pre_save() {
    if (system()) {
      variables.no_note = serializeJSON(note_data());
    } else {
      variables.no_note = new app.services.jSoup(variables.no_note ?: '').text();
    }
  }
}
