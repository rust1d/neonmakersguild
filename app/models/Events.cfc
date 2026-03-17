component extends=BaseModel accessors=true {
  property name='ev_evid'        type='numeric'  sqltype='integer'    primary_key;
  property name='ev_usid'        type='numeric'  sqltype='integer';
  property name='ev_google_id'   type='string'   sqltype='varchar';
  property name='ev_summary'     type='string'   sqltype='varchar';
  property name='ev_location'    type='string'   sqltype='varchar';
  property name='ev_description' type='string'   sqltype='varchar';
  property name='ev_allday'      type='boolean'  sqltype='tinyint'    default=0;
  property name='ev_timezone'   type='string'    sqltype='varchar'    default='America/New_York';
  property name='ev_start'       type='date'     sqltype='timestamp';
  property name='ev_end'         type='date'     sqltype='timestamp';
  property name='ev_added'       type='date';
  property name='ev_dla'         type='date';

  has_one(name: 'User', class: 'Users', key: 'ev_usid', relation: 'us_usid');

  public boolean function editable() {
    return session.user.loggedIn() && (session.user.admin() || session.user.usid() == variables.ev_usid);
  }

  public string function start_date() {
    if (isNull(variables.ev_start) || !isDate(variables.ev_start)) return '';
    return dateFormat(variables.ev_start, 'yyyy-mm-dd');
  }

  public string function start_time() {
    if (isNull(variables.ev_start) || !isDate(variables.ev_start) || variables.ev_allday) return '';
    return timeFormat(variables.ev_start, 'HH:nn');
  }

  public string function end_date() {
    if (isNull(variables.ev_end) || !isDate(variables.ev_end)) return '';
    return dateFormat(variables.ev_end, 'yyyy-mm-dd');
  }

  public string function end_time() {
    if (isNull(variables.ev_end) || !isDate(variables.ev_end) || variables.ev_allday) return '';
    return timeFormat(variables.ev_end, 'HH:nn');
  }

  public string function timezone() {
    return isNull(variables.ev_timezone) || !len(variables.ev_timezone) ? 'America/New_York' : variables.ev_timezone;
  }

  public string function timezone_abbr() {
    var tz = timezone();
    if (!tz.len()) return 'EST';
    var map = {
      'America/New_York': 'EST', 'America/Chicago': 'CST', 'America/Denver': 'MST',
      'America/Los_Angeles': 'PST', 'America/Anchorage': 'AKST', 'Pacific/Honolulu': 'HST',
      'Europe/London': 'GMT', 'Europe/Paris': 'CET', 'Europe/Berlin': 'CET',
      'Asia/Tokyo': 'JST', 'Australia/Sydney': 'AEST'
    };
    return map[tz] ?: tz;
  }

  public string function month_key() {
    if (isNull(variables.ev_start) || !isDate(variables.ev_start)) return '';
    return dateFormat(variables.ev_start, 'yyyy-mm');
  }

  public string function month_label() {
    if (isNull(variables.ev_start) || !isDate(variables.ev_start)) return '';
    return dateFormat(variables.ev_start, 'mmmm yyyy');
  }

  public query function search(struct params) {
    if (arguments.keyExists('params')) arguments = arguments.params;
    if (!isNumeric(arguments.get('maxrows'))) arguments.maxrows = -1;

    var sproc = new StoredProc(procedure: 'events_search', datasource: datasource());
    sproc.addParam(cfsqltype: 'integer', value: arguments.get('ev_evid'),      null: !arguments.keyExists('ev_evid'));
    sproc.addParam(cfsqltype: 'integer', value: arguments.get('ev_usid'),      null: !arguments.keyExists('ev_usid'));
    sproc.addParam(cfsqltype: 'varchar', value: arguments.get('ev_google_id'), null: !arguments.keyExists('ev_google_id'));
    sproc.addParam(cfsqltype: 'varchar', value: arguments.get('term'),         null: !arguments.keyExists('term'));
    sproc.addProcResult(name: 'qry', resultset: 1, maxrows: arguments.maxrows);
    return paged_search(sproc, arguments);
  }
}
