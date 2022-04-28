component accessors = true {
  property name='to'          type='string';
  property name='from'        type='string';
  property name='subject'     type='string';
  property name='type'        type='string'  default='html';
  property name='body'        type='string';
  property name='attachments' type='array';

  public AdminEmailer function init(struct params) {
    if (arguments.keyExists('params')) arguments = arguments.params;
    for (var param in arguments) variables[param] = arguments[param];
    variables.attachments = [];

    param variables.to = application.email.admin;
    param variables.from = application.email.support;;

    return this;
  }

  public void function attach(required string filename, string type = 'text/plain') {
    variables.attachments.append(arguments);
  }

  public void function send() {
    if (application.isDevelopment) log_email();

    send_email();
  }

  public void function send_dump(required any dump) {
    setBody(dump_obj(dump));
    send();
  }

  public void function send_error(any err, any args, any data) {
    var dump = '';
    var msg = [];
    msg.append('http://#cgi.server_name##cgi.script_name#?#cgi.query_string#');
    msg.append('Time: #now().dateTimeFormat("yyyy/mm/dd HH:nn:ss")#');
    if (arguments.keyExists('err')) {
      if (err.keyExists('message')) msg.append('Message: #err.message#');
      if (err.keyExists('detail')) msg.append('Details: #err.detail#');
      if (err.keyExists('type')) msg.append('Type: #err.type#');
      msg.append('<hr>' & dump_obj(err));
    }
    if (arguments.keyExists('args')) msg.append('<hr>ARGUMENTS:' & dump_obj(args));
    if (arguments.keyExists('data')) msg.append('<hr>DATA:' & dump_obj(args));
    msg.append('<hr>FORM:' & dump_obj(form));
    msg.append('<hr>CGI:' & dump_obj(cgi));
    if (isDefined('session')) msg.append('<hr>SESSION:' & dump_obj(session));

    variables.body = msg.toList('<br>');
    send();
  }

  public void function send_form() {
    savecontent variable='variables.body' {
      writeOutput('
        <html>
          <head>
            <style type="text/css">
              table,p,h1,h2,h3,h4,h5,h6 {font-family:"Segoe UI", Helvetica, sans-serif;font-size:1em;line-height:1.3em;}
              table {width:640px;}
              td {padding:2px 10px 3px 3px; vertical-align:top;}
              td.key {width: 150px;}
              td.user {white-space: pre-wrap;overflow-wrap: break-word;}
            </style>
          </head>
          <body>
            <table>'); for (var key in form.fieldnames.listToArray()) writeOutput('
              <tr>
                <td class="key">#key.replace("_"," ","all")#</td>
                <td class="user">#encodeForHTML(form.get(key))#</td>
              </tr>'); writeOutput('
              <tr><td class="key"><br /></td><td>&nbsp;</td></tr>
              <tr><td class="key">Referrer</td><td>#CGI.http_referer.listLast('=')#</td></tr>
              <tr><td class="key">IP</td><td>#CGI.remote_addr#</td></tr>
              <tr><td class="key">Time</td><td>#DateTimeFormat(now(),"EEE, MMM d, yyyy @ HH:nn z")#</td></tr>
            </table>
          </body>
        </html>'
      );
    }
    send();
  }

  // PRIVATE

  private string function dump_obj(required any obj) {
    savecontent variable='data' { writeDump(obj) };

    return data;
  }

  private void function log_email() {
    writeLog(file: 'adminEmailer', text: SerializeJSON(this));
  }

  private void function send_email() {
    var env_subject = '#application.applicationname#-#application.env.uCase()# ' & getSubject();
    var mailer = new mail();
    mailer.setTo(getTo());
    mailer.setFrom(getFrom());
    mailer.setSubject(env_subject);
    mailer.setType(getType());
    for (var attachment in attachments) {
      mailer.addParam(file=attachment.filename, type=attachment.type);
    }
    try {
      mailer.send(body: getBody());
    } catch (any err) {
      var data = { err: err, data: this };
      writeLog(file: 'adminEmailer', text: SerializeJSON(data));
    }
  }
}
