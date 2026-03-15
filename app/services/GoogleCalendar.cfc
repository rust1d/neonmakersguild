component {

  variables._calendar_id = '';
  variables._service_email = '';
  variables._private_key = '';
  variables._token_uri = '';
  variables._access_token = '';
  variables._token_expires = now();

  public GoogleCalendar function init() {
    var config = application.secrets.google;
    variables._calendar_id = config.calendar_id;
    variables._service_email = config.service_account_email;
    variables._private_key = config.private_key;
    variables._token_uri = config.token_uri;
    return this;
  }

  public struct function create_event(
    required string summary,
    required string start_date,
    required string end_date,
    string description = '',
    string location = '',
    boolean all_day = false,
    string timezone = 'America/New_York'
  ) {
    var token = get_access_token();
    var event = build_event_body(argumentcollection: arguments);

    var url = 'https://www.googleapis.com/calendar/v3/calendars/' & encodeForURL(variables._calendar_id) & '/events';
    var http = new http(method: 'POST', url: url, charset: 'utf-8');
    http.addParam(type: 'header', name: 'Authorization', value: 'Bearer ' & token);
    http.addParam(type: 'header', name: 'Content-Type', value: 'application/json');
    http.addParam(type: 'body', value: serializeJSON(event));

    var result = http.send().getPrefix();
    var response = deserializeJSON(result.fileContent);

    if (result.statusCode contains '200' || result.statusCode contains '201') {
      return { 'success': true, 'event': response };
    }

    throw(
      type: 'GoogleCalendarError',
      message: response.error.message ?: 'Unknown error',
      detail: result.statusCode
    );
  }

  public struct function update_event(
    required string event_id,
    required string summary,
    required string start_date,
    required string end_date,
    string description = '',
    string location = '',
    boolean all_day = false,
    string timezone = 'America/New_York'
  ) {
    var token = get_access_token();
    var event = build_event_body(argumentcollection: arguments);

    var url = 'https://www.googleapis.com/calendar/v3/calendars/' & encodeForURL(variables._calendar_id) & '/events/' & arguments.event_id;
    var http = new http(method: 'PUT', url: url, charset: 'utf-8');
    http.addParam(type: 'header', name: 'Authorization', value: 'Bearer ' & token);
    http.addParam(type: 'header', name: 'Content-Type', value: 'application/json');
    http.addParam(type: 'body', value: serializeJSON(event));

    var result = http.send().getPrefix();
    var response = deserializeJSON(result.fileContent);

    if (result.statusCode contains '200') {
      return { 'success': true, 'event': response };
    }

    throw(
      type: 'GoogleCalendarError',
      message: response.error.message ?: 'Unknown error',
      detail: result.statusCode
    );
  }

  public struct function delete_event(required string event_id) {
    var token = get_access_token();
    var url = 'https://www.googleapis.com/calendar/v3/calendars/' & encodeForURL(variables._calendar_id) & '/events/' & arguments.event_id;
    var http = new http(method: 'DELETE', url: url, charset: 'utf-8');
    http.addParam(type: 'header', name: 'Authorization', value: 'Bearer ' & token);

    var result = http.send().getPrefix();

    if (result.statusCode contains '204' || result.statusCode contains '200') {
      return { 'success': true };
    }

    throw(
      type: 'GoogleCalendarError',
      message: 'Failed to delete event',
      detail: result.statusCode
    );
  }

  public array function list_events(numeric max_results = 250) {
    var token = get_access_token();
    var url = 'https://www.googleapis.com/calendar/v3/calendars/' & encodeForURL(variables._calendar_id) & '/events?maxResults=' & arguments.max_results & '&orderBy=startTime&singleEvents=true';
    var http = new http(method: 'GET', url: url, charset: 'utf-8');
    http.addParam(type: 'header', name: 'Authorization', value: 'Bearer ' & token);

    var result = http.send().getPrefix();
    var response = deserializeJSON(result.fileContent);

    if (result.statusCode contains '200') {
      return response.items ?: [];
    }

    throw(
      type: 'GoogleCalendarError',
      message: response.error.message ?: 'Unknown error',
      detail: result.statusCode
    );
  }

  // PRIVATE

  private struct function build_event_body(
    required string summary,
    required string start_date,
    required string end_date,
    string description = '',
    string location = '',
    boolean all_day = false,
    string timezone = 'America/New_York'
  ) {
    var event = {
      'summary': arguments.summary,
      'description': arguments.description,
      'location': arguments.location
    };

    if (arguments.all_day) {
      event['start'] = { 'date': arguments.start_date };
      event['end'] = { 'date': arguments.end_date };
    } else {
      event['start'] = { 'dateTime': arguments.start_date, 'timeZone': arguments.timezone };
      event['end'] = { 'dateTime': arguments.end_date, 'timeZone': arguments.timezone };
    }

    return event;
  }

  private string function get_access_token() {
    if (variables._access_token.len() && now() < variables._token_expires) {
      return variables._access_token;
    }

    var iat = int(createObject('java', 'java.lang.System').currentTimeMillis() / 1000);
    var exp = iat + 3600;

    var header = toBase64Url(serializeJSON({ 'alg': 'RS256', 'typ': 'JWT' }));
    var claims = toBase64Url(serializeJSON({
      'iss': variables._service_email,
      'scope': 'https://www.googleapis.com/auth/calendar',
      'aud': variables._token_uri,
      'iat': iat,
      'exp': exp
    }));

    var signing_input = header & '.' & claims;
    var signature = toBase64Url(sign_rs256(signing_input, variables._private_key));
    var jwt = signing_input & '.' & signature;

    var http = new http(method: 'POST', url: variables._token_uri, charset: 'utf-8');
    http.addParam(type: 'formfield', name: 'grant_type', value: 'urn:ietf:params:oauth:grant-type:jwt-bearer');
    http.addParam(type: 'formfield', name: 'assertion', value: jwt);

    var result = http.send().getPrefix();
    var response = deserializeJSON(result.fileContent);

    if (!response.keyExists('access_token')) {
      throw(type: 'GoogleAuthError', message: response.error_description ?: 'Failed to obtain access token');
    }

    variables._access_token = response.access_token;
    variables._token_expires = dateAdd('s', response.expires_in - 60, now());
    return variables._access_token;
  }

  private binary function sign_rs256(required string input, required string pem_key) {
    var key_string = arguments.pem_key
      .replace('-----BEGIN PRIVATE KEY-----', '')
      .replace('-----END PRIVATE KEY-----', '')
      .replace(chr(10), '')
      .replace(chr(13), '')
      .trim();

    var key_bytes = toBinary(key_string);
    var key_spec = createObject('java', 'java.security.spec.PKCS8EncodedKeySpec').init(key_bytes);
    var key_factory = createObject('java', 'java.security.KeyFactory').getInstance('RSA');
    var private_key = key_factory.generatePrivate(key_spec);

    var sig = createObject('java', 'java.security.Signature').getInstance('SHA256withRSA');
    sig.initSign(private_key);
    sig.update(charsetDecode(arguments.input, 'utf-8'));
    return sig.sign();
  }

  private string function toBase64Url(required any input) {
    var b64 = isBinary(arguments.input) ? toBase64(arguments.input) : toBase64(charsetDecode(arguments.input, 'utf-8'));
    return b64.replace('+', '-', 'all').replace('/', '_', 'all').replace('=', '', 'all');
  }

}
