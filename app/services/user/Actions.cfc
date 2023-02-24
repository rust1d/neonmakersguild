component {
  remote struct function unsubscribe() returnFormat='json' {
    try {
      var response = new_response();
      var usid = request.router.decode('usid');
      if (usid) {
        var mUser = new app.models.Users().find(usid); // CONFIRM USER EXISTS
        var cnt = new app.models.Subscriptions().delete_by_user(usid);
        var msg = application.utility.plural_label(cnt, 'subscription');
        response.data.messages = 'Found and deleted #msg#.';
      } else {
        response.data.messages = 'You successfully deleted all requests!';
      }
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