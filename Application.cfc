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
  }

  this.javaSettings = {
    LoadPaths: ['/assets/java/'],
    loadColdFusionClassPath: true,
    reloadOnChange: true
  }

  public boolean function onApplicationStart() {
    set_environment();
    load_secrets();
    load_singletons();

    application.dsn = 'neonmakersguild';
    application.email.support = 'support@neonmakersguild.org';
    application.email.supportplus = 'Neon Makers Guild <#application.email.support#>';
    application.email.membership = 'membership@neonmakersguild.org';
    application.paths.root = ExpandPath('\');
    application.paths.images = application.paths.root & 'assets\images\';
    application.paths.documents = application.paths.root & 'assets\documents\';
    application.paths.templates = '\app\views\templates\';
    application.urls.cdn = 'https://neonmg.s3.amazonaws.com';
    application.urls.images = '/assets/images';
    application.urls.documents = '/assets/documents';
    application.urls.paypalme = 'https://paypal.me/neonmakersguild/50';
    application.s3.root = 's3://' & application.secrets.s3.accessKeyId & ':' & application.secrets.s3.secretAccessKey;
    application.s3.bucket = application.s3.root & '@neonmg';
    application.settings.title = 'Neon Makers Guild';
    application.settings.tiny = 'g2016x44cjzgv7h689qtbieaowb03dksphmy0umsojeab13b';
    application.settings.renewal_grace_period = 42; // HOW MANY DAYS CAN USER DELAY PAYING
    application.settings.renewal_reminder_cooldown = 2; // HOW OFTEN CAN AN ADMIN SEND A REMINDER EMAIL

    return true;
  }

  public void function onSessionStart() {
    lock scope='session' type='exclusive' timeout='10' {
      session.started = now();
      session.user = new app.services.CurrentUser();
      session.site = new app.services.CurrentSite('nmg');
      session.return_to = '';
    }
  }

  public void function onRequestStart(required string requestname)  {
    param request.pageName = '';
    check_reset_app();
    check_user_logout();
    clean_form();
    check_redirects();
    request.s3Service = get_cloud_service();
    request.router =  new app.services.router('home', session.site.path());
    request.utility = application.utility;
  };

  public boolean function onMissingTemplate(string targetpage) {
    writelog(file: '404', text: '#arguments.targetpage#?#cgi.query_string#');
    new app.services.email.AdminEmailer(subject: 'onMissingTemplate').send_error(args: arguments);
    // location(application.urls.root & '/index.cfm', false);
    return true;
  };

  public void function onError(any exception, string eventName) output='true'  {
    // writeLog(text: arguments.eventname, type: 'error', file: 'neonmakersguildErrorLog');
    // writeLog(text: arguments.exception.message, type: 'error', file: 'neonmakersguildErrorLog');

    if (application.isDevelopment) {
      writeDump(arguments);
      return;
    }

    if (application.keyExists('sentry')) {
      var data = {};
      // try { data = isDefined('session') ? session.user.dump() : {} } catch (any err) {}
      application.sentry.captureException(exception: arguments.exception, additionalData: data);
    }
    if (isDefined('application.email.support')) {
      new app.services.email.AdminEmailer(subject: 'Application Error').send_error(arguments.exception);
    } else {
      writedump(arguments.exception);
    }
  };

  // PRIVATE

  private void function check_redirects() {
    if (session.user.expired()) {
      url.p = 'user/renew';
      return;
    }
    new app.services.sites.redirects().perform();
  }

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
      // TEXTAREAS THAT WE EXPECT HTML IN MUST BE WHITELISTED
      if (listfindNoCase('up_bio,ben_body,bpa_body,btb_body,fm_body,edit_message', key)) continue;
      form[key] = form[key].reReplace('<[^>]*>', '', 'all').reReplace('[<>]', '?', 'all');
    }
  }

  public string function expand_path(required string data) {
    var path = data.replace('/', '\', 'all'); // SWITCH TO \
    var trailing = path.right(1)=='\' ? '\' : ''; // PRESERVES TRAILING SLASH
    path = path.listToArray('\').toList('\'); // REMOVES LEADING AND TRAILING SLASH
    return application.paths.root & path & trailing;
  }

  private any function get_cloud_service() {
    try {
      return getCloudService(application.secrets.s3, application.secrets.s3Conf);
    } catch (any err) {
      return { // fake service CF 2018
        bucket: function(val) {
          return {
            uploadFile: function(params) {
              try {
                fileCopy(params.srcFile, application.s3.bucket & '/' & params.key);
              } catch (any err) {
                return { status: application.utility.errorString(err) };
              }
              return { status: 'success' };
            },
            delete: function(params) {
              try {
                fileDelete(application.s3.bucket & '/' & params.key);
              } catch (any err) {
                return { status: application.utility.errorString(err) };
              }
              return { status: 'success' };
            }
          }
        }
      }
    }
  }

  private void function load_secrets() {
    application.secrets = deserializeJSON(fileRead(ExpandPath('..') & '/nmg.json'));
    application.cache_key = fileRead(expandPath('\.cache_key')).left(13);
  }

  private void function load_singletons() {
    application.utility = new app.services.utility();
    application.bcrypt = new app.services.bcrypt();
    application.flash = new app.services.flash();
    application.indexer = new app.services.Indexer();
    // application.sentry = new services.sentry(
    //   release: '1.000',
    //   environment: application.env,
    // );
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
    application.email.admin = 'rust1d@usa.net';
    application.urls.root = 'https://local.neonmakersguild.org';
  }

  private void function setup_staging() {
    application.env = 'staging';
    application.email.admin = 'rust1d@usa.net';
    application.urls.root = 'https://staging.neonmakersguild.org';
  }

  private void function setup_production() {
    application.env = 'production';
    application.email.admin = 'rust1d@usa.net';
    application.urls.root = 'https://neonmakersguild.org';
  }
}
