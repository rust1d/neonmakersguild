component {
  remote struct function perform(string p) returnFormat='json' {
    var response = new_response();
    try {
      response.data = new scheduler.forum().send_alerts();
    } catch (any err) {
      writedump(err);
      response = error_response(err);
    }
    logger(response);
    return response;
  }

  // PRIVATE

  private struct function error_response(required any err) {
    var response = new_response();
    response.success = false;
    response.errors.append(application.utility.errorString(err));
    return response;
  }

  private void function logger(struct response) {
    new app.services.DailyLogger(type: 'subscriptions').log(SerializeJSON(response));
  }

  private struct function new_response() {
    return { 'success': true, 'errors': [], 'data': {} };
  }
}
