component {
  this.name = 'neonmakersguild';
  this.applicationTimeout = createTimeSpan(0, 12, 0, 0);
  this.sessionmanagement = true;
  this.clientmanagement = false;
  this.sessiontimeout = createTimeSpan(0, 1, 20, 0);
  this.scriptProtect = 'all';
  this.setClientCookies = true;
  this.showDebugOutput = true;
  this.enablecfoutputonly = false;
  this.mappings = {
    '/views': ExpandPath('/app/views'),
    '/site': ExpandPath('/app/views/site'),
    '/cfc': ExpandPath('/assets/cfc'),
    '/services':ExpandPath('/app/services')
  };

  public boolean function onApplicationStart() {
    set_environment();
    load_secrets();
    load_singletons();
    set_smtp_server();

    application.dsn = 'neonmakersguild';
    application.email.support = 'support@neonmakersguild.org';
    application.email.supportplus = 'Neon Makers Guild <#application.email.support#>';
    application.paths.root = ExpandPath('\');
    application.paths.images = application.paths.root & 'assets\images\';
    application.urls.images = application.urls.root & '/assets/images';
    application.settings.title = 'Neon Makers Guild';
    application.settings.tiny = 'g2016x44cjzgv7h689qtbieaowb03dksphmy0umsojeab13b';

    return true;
  }

  public void function onSessionStart() {
    lock scope='session' type='exclusive' timeout='10' {
      session.started = now();
      session.user = new app.services.CurrentUser();
      session.site = new app.services.CurrentSite();
      session.return_to = '';
    }
  }

  public void function onRequestStart(required string requestname)  {
    param request.pageName = '';
    check_reset_app();
    check_user_logout();
    clean_form();
    request.router =  new app.services.router('home', session.site.path());
  };

  public boolean function onMissingTemplate(string targetpage) {
    writelog(file: '404', text: '#arguments.targetpage#?#cgi.query_string#');
    new app.services.AdminEmailer(subject: 'onMissingTemplate').send_error(args: arguments);
    // location(application.urls.root & '/index.cfm', false);
writedump(arguments);
    return true;
  };

  public void function onError(any exception, string eventName) output='true'  {
    writeLog(text: arguments.eventname, type: 'error', file: 'neonmakersguildErrorLog');
    writeLog(text: arguments.exception.message, type: 'error', file: 'neonmakersguildErrorLog');

    if (application.isDevelopment) {
      writeDump(arguments);
      return;
    }

    if (application.keyExists('sentry')) {
      var data = {};
      // try { data = isDefined('session') ? session.user.dump() : {} } catch (any err) {}
      application.sentry.captureException(exception: arguments.exception, additionalData: data);
    }
    new app.services.AdminEmailer(subject: 'Application Error').send_error(arguments.exception);
  };

  // PRIVATE
  private void function check_reset_app() {
    if (url.keyExists('resetMyApp')) {
      structClear(application);
      applicationStop();
      this.onApplicationStart();
      this.onSessionStart();
      writeoutput('Application reset.');
      abort;
    } else if (application.isDevelopment) { // ALWAYS RELOAD IN DEV ENV
      set_environment();
      load_singletons();
    }
  }

  private void function check_user_logout() {
    if (url.keyExists('ref') && session.site.get_site()!=url.ref) {
      // this.onSessionStart();
      session.site = new app.services.CurrentSite();
    } else if (url.keyExists('logout') && session.user.loggedIn()) {
      this.onSessionStart();
    }
  }

  private void function clean_form() {
    if (!form.keyExists('fieldnames') || form.fieldnames.len() == 0) return;

    for (key in form.fieldnames.listToArray()) {
      request.unclean[key] = form[key].reReplace('[^\x00-\x7F]', '-', 'all').trim();
      form[key] = request.unclean[key];
      if (listfindNoCase('up_bio,ben_body,ben_morebody', key)) continue;
      form[key] = form[key].reReplace('<[^>]*>', '', 'all').reReplace('[<>]', '?', 'all');
    }
  }

  private void function load_secrets() {
    application.secrets = deserializeJSON(fileRead(ExpandPath('..') & '/nmg.json'));
  }

  private void function load_singletons() {
    application.utility = new services.utility();
    application.bcrypt = new services.bcrypt();
    application.flash = new services.flash();
    // application.sentry = new services.sentry(
    //   release: '1.000',
    //   environment: application.env,
    //   dsn: 'https://74c50251b26c41bd93a6fbf8110f3730:0c2e1136c88d4928ac6d090eac70adf8@sentry.io/5326807'
    // );
  }

  private void function set_smtp_server() {
    application.smtp = {
      hostek: {
        server: 'mail13.ezhostingserver.com',
        username: 'mailadmin@neonmakersguild.org',
        port: 587,
        useTLS: true
      },
      local: {
        server: 'mail13.ezhostingserver.com',
        username: 'mailadmin@neonmakersguild.org',
        port: 587,
        useTLS: true
      }
    }
    application.smtp.append(application.smtp.local);
  }

  private void function set_environment() {
    switch (cgi.server_name) {
      case 'local.neonmakersguild.org':
        setup_development();
        break;
      case 'staging.neonmakersguild.org':
        setup_staging();
        break;
      default:
        setup_production();
    }
    for (local.env in 'development,staging,production') {
      application['is#env#'] = (application.env == local.env);
    }
  }

  private void function setup_development() {
    application.env = 'development';
    application.email.admin = 'john@neonmakersguild.org';
    application.urls.root = 'http://local.neonmakersguild.org';
  }

  private void function setup_staging() {
    application.env = 'staging';
    application.email.admin = 'john@neonmakersguild.org';
    application.urls.root = 'https://staging.neonmakersguild.org';
  }

  private void function setup_production() {
    application.env = 'production';
    application.email.admin = 'eve@neonmakersguild.org';
    application.urls.root = 'https://neonmakersguild.org';
  }
}
