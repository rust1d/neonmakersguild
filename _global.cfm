<!--- GLOBAL SCRIPTS FOR ENTIRE SITE --->
<cfscript>
  setting showdebugoutput = !application.isProduction;

  public boolean function return_error(required string message) {
    application.flash.error(message);
    return false;
  }

  void function include_js(required string data) {
    if (data.isEmpty()) return;
    var path = '#application.urls.root#/#data#?ck=#application.cache_key#';
    if (request.layout_head.findNoCase(path)) return;
    request.layout_head &= '<script type="text/javascript" src="#path#"></script>' & chr(10);
  }

  variables.router = request.router;
  variables.utility = application.utility;
  variables.between = utility.between;
  variables.ifin = utility.ifin;
  variables.safe_save = utility.safe_save;
  variables.flash = application.flash;

  if (form.keyExists('btnView')) session.user.view(form.btnView);
</cfscript>
