component {
  public AuthToken function init() {
    variables.utility = application.utility;
    return this;
  }

  public struct function current_password_code(required date dla) {
    return generate_code(2, dla, 600); // 5 mins
  }

  public struct function detoken(required string token) {
    var data = { success: false, error: '', token: token }
    try {
      var dec = utility.decode(token);
      var parts = dec.listToArray();
      data.expires = dehex(parts[1]);
      data.pkid = dehex(parts[2]);
      data.dla = dehex(parts[3]);
      data.user = parts[4];
      data.now = since();
      data.seconds_left = data.expires - since();
      if (data.seconds_left < 0) {
        data.error = 'Expired Token';
        return data;
      }
      var dll = get_last_login(data.pkid);
      data.login = since(dll);
      data.success = (data.login == data.dla) ? true : false;

      if (!data.success) data.error = 'Last login changed';
    } catch (any err) {
      data.error = ArrayToList([ err.errorCode, err.type, err.message, err.detail ]);
    }
    return data;
  }

  public void function indirect_login(required string token) {
    var data = detoken(token);
    if (data.success) {
      application.flash.success('Login successful. You should probably change your password.');
      session.return_to = 'index.cfm?p=user/security';
      new app.services.Login().login(user: data.user, password: '', pkid: data.pkid);
    }

    request.router.redirect('login/login');
  }

  public string function magic_link(required Users mUser) { // EXPECTS A ROW FROM login_lookup SPROC
    return application.urls.root & '/?p=login/login&auth=' & token(mUser, 600); // 5 minute token
  }

  public string function token(required Users mUser, numeric seconds_to_live = 10) {
    var data = [
      hex(since() + seconds_to_live),
      hex(mUser.usid()),
      hex(since(mUser.dll())),
      mUser.user()
    ];
    return utility.encode(data.toList());
  }

  // PRIVATE

  private numeric function dehex(required string data) {
    return inputBaseN(data, 16);
  }

  private struct function generate_code(required date dla, numeric sec_to_live=120) {
    var sec_past_year = since(now()); // SECONDS SINCE START OF YEAR (MAX=31536000)
    var cycler = ceiling(sec_past_year / sec_to_live); // THIS VALUE WILL CHANGE EVERY "sec_to_live" SECONDS AND BE UNIQUE FOR 1 YEAR
    var sec_past_login = since(dla); // SECONDS SINCE SOME DATE ATTACHED TO THE USER - USED AS A SEED
    var multipler = right(sec_past_login, 4); // UNIQUEISH VALUE THAT VARIES BASED ON CODE TYPE AND DLA
    var val = cycler * multipler;
    var code = right('000000' & val, 6);
    return {
      life: sec_to_live,
      code: code
    }
  }

  private date function get_last_login(required numeric pkid) {
    try {
      var mUser = new app.models.Users().find(pkid);
      if (isDate(mUser.dll())) return mUser.dll();
    } catch (any err) { }
    return createDateTime(2021, 1, 1, 1, 1, 1);
  }

  private string function hex(required numeric data) {
    return formatBaseN(data, 16);
  }

  private numeric function since(date data) {
    param arguments.data = now();
    var jan1 = createDate(now().year(), 1, 1);
    return min(31536000, abs(data.diff('s', jan1)));
  }
}
