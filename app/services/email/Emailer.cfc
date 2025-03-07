component accessors = true {
  property name='from'            type='string'  default='support@neonmakersguild.org';
  property name='to'              type='string';
  property name='failto'          type='string'  default='no-reply@neonmakersguild.org';
  property name='cc'              type='string';
  property name='bcc'             type='string';
  property name='subject'         type='string';
  property name='type'            type='string'  default='html';
  property name='body'            type='string';
  property name='template'        type='string';
  property name='testmode'        type='boolean' default=false;
  property name='mailer_files'    type='struct';
  property name='spoolenable'     type='boolean' default=true;

  public Emailer function init(struct params) {
    variables.mailer_files = {};
    set(argumentcollection = arguments);
    if (application.isDevelopment) variables.to = application.email.admin;

    return this;
  }

  public void function send() {
    try {
      send_email();
      log_email();
    } catch (any err) {
      if (variables.testmode) {
        writedump(err);
        return;
      }
      new AdminEmailer(subject: 'Emailer Failed').send_error(err, this);
    }
  }

  public void function set(struct params) {
    if (arguments.keyExists('params')) arguments = arguments.params;

    for (var key in arguments) variables[key] = arguments[key];
  }

  public void function setFile(required string contentid, string file_name) {
    if (arguments.keyExists('file_name')) {
      variables.mailer_files[contentid] = new EmailerFile(argumentcollection = arguments);
    } else {
      variables.mailer_files.delete(contentid);
    }
  }

  public void function setFiles(required struct files) {
    for (var key in files) setFile(key, files[key]);
  }

  // PRIVATE

  private void function add_file_params() {
    for (var key in mailer_files) {
      var mMailerFile = mailer_files[key];
      variables.mailer.addParam(argumentcollection: mMailerFile.params());
    }
  }

  private void function generate_body() {
    if (isNull(variables.template)) return;

    var template_path = application.paths.templates & variables.template;
    if (!fileExists(application.paths.root & template_path)) {
      variables.body = 'misssing template ' & template_path;
      return;
    }

    savecontent variable='variables.body' {
      include template_path;
    }
  }

  private void function log_email() {
    new app.services.DailyLogger(type: 'emailer').log(SerializeJSON(this));
  }

  private void function send_email() {
    variables.mailer = new mail(argumentcollection: application.secrets.smtp);
    variables.mailer.setFrom(getFrom());
    variables.mailer.setTo(getTo());
    // variables.mailer.setFailTo(getFailTo());
    variables.mailer.setCc(getCc());
    variables.mailer.setBcc(getBcc());
    variables.mailer.setSubject(getSubject());
    variables.mailer.setType(getType());
    variables.mailer.setSpoolenable(getSpoolenable());
    generate_body();
    variables.mailer.setBody(getBody());
    add_file_params();
    variables.mailer.send();
  }
}
