component {
  remote struct function autocomplete() returnFormat='json' {
    try {
      var data = json_content();
      var response = new_response();
      response.data['rows'] = [];

      if (len(data.get('tag')) > 0) {
        param data.blog = 1;
        var qry = new app.models.Tags().search(tag_blog: data.blog, tag_tag: data.tag & '%');
        for (var row in qry) {
          response.data.rows.append({
            'id': row.tag_tagid,
            'value': row.tag_tag,
            'label': row.tag_tag
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
    response.errors.append(application.utilityCFC.errorString(err));
    return response;
  }

  private struct function json_content() {
    try {
      return DeserializeJSON(getHTTPRequestData().content);
    } catch (any err) {
      throw(message: 'Bad Request', detail: 'JSON is invalid', errorCode: 400, extendedinfo: err.detail);
    }
  }

  private struct function new_response() {
    return { 'success': true, 'errors': [], 'data': {} };
  }
}
