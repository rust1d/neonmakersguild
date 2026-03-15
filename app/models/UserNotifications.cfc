component extends=BaseModel accessors=true {
  property name='un_unid'    type='numeric'   sqltype='integer'   primary_key;
  property name='un_usid'    type='numeric'   sqltype='integer';
  property name='un_type'    type='string'    sqltype='varchar';
  property name='un_ref_id'  type='numeric'   sqltype='integer';
  property name='un_message' type='string'    sqltype='varchar';
  property name='un_data'    type='string'    sqltype='varchar';
  property name='un_read'    type='numeric'   sqltype='integer'   default=0;
  property name='un_added'   type='date';

  has_one(name: 'User', class: 'Users', key: 'un_usid', relation: 'us_usid');

  public boolean function owned_by(required numeric usid) {
    return persisted() && variables.un_usid == arguments.usid;
  }

  public boolean function mark_read() {
    variables.un_read = 1;
    return safe_save();
  }

  public struct function data() {
    try {
      return deserializeJSON(variables.un_data ?: '{}');
    } catch (any e) {
      return {};
    }
  }

  public string function link() {
    return data().link ?: '';
  }

  public string function from_user() {
    return data().from_user ?: '';
  }

  public numeric function from_usid() {
    return data().from_usid ?: 0;
  }

  public numeric function unread_count(required numeric usid) {
    return count(un_usid: arguments.usid, un_read: 0);
  }

  public void function mark_all_read(required numeric usid) {
    queryExecute(
      "UPDATE usernotifications SET un_read = 1 WHERE un_usid = :usid AND un_read = 0",
      { usid: { value: arguments.usid, cfsqltype: 'integer' } },
      { datasource: datasource() }
    );
  }

  public void function notify(
    required numeric usid,
    required string type,
    required string message,
    struct data = {}
  ) {
    new UserNotifications({
      un_usid: arguments.usid,
      un_type: arguments.type,
      un_ref_id: arguments.data.ref_id ?: 0,
      un_message: arguments.message,
      un_data: serializeJSON(arguments.data),
      un_read: 0
    }).safe_save();
  }

  public query function search(struct params) {
    if (arguments.keyExists('params')) arguments = arguments.params;

    var sproc = new StoredProc(procedure: 'usernotifications_search', datasource: datasource());
    sproc.addParam(cfsqltype: 'integer', value: arguments.get('un_unid'), null: !arguments.keyExists('un_unid'));
    sproc.addParam(cfsqltype: 'integer', value: arguments.get('un_usid'), null: !arguments.keyExists('un_usid'));
    sproc.addParam(cfsqltype: 'varchar', value: arguments.get('un_type'), null: !arguments.keyExists('un_type'));
    sproc.addParam(cfsqltype: 'integer', value: arguments.get('un_read'), null: !arguments.keyExists('un_read'));
    sproc.addProcResult(name: 'qry', resultset: 1);

    return paged_search(sproc, arguments);
  }
}
