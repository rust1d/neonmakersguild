component {
  remote struct function mentions() returnFormat='json' {
    try {
      var data = json_content();
      var response = new_response();
      response.data['users'] = [];

      var term = data.get('term') ?: '';
      if (term.len() >= 1) {
        var qry = new app.models.Users().search(lookup: term, isdeleted: 0, maxrows: 10);
        for (var row in qry) {
          response.data.users.append({
            'usid': row.us_usid,
            'user': row.us_user
          });
        }
      }
      return response;
    } catch (any err) {
      return error_response(err);
    }
  }

  private struct function error_response(required any err) {
    var response = new_response();
    response.success = false;
    response.errors.append(application.utility.errorString(err));
    return response;
  }

  private struct function json_content() {
    try {
      return DeserializeJSON(getHTTPRequestData().content);
    } catch (any err) {
      throw(message: 'Bad Request', detail: 'JSON is invalid', errorCode: 400);
    }
  }

  private struct function new_response() {
    return { 'success': true, 'errors': [], 'data': {} };
  }
}
