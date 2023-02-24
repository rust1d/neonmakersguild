component {
  remote struct function perform() returnFormat='json' {
    try {
      var response = new_response();

      new scheduler.forum().send_alerts();

      return response;
    } catch (any err) {
      return error_response(err);
    }
  }

  // PRIVATE

  private struct function error_response(required any err) {
    var response = new_response();
    response.success = false;
    response.errors.append(application.utility.errorString(err));
    return response;
  }

  private struct function new_response() {
    return { 'success': true, 'errors': [], 'data': {} };
  }

}