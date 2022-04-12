<!--- GLOBAL SCRIPTS FOR ENTIRE SITE --->
<cfscript>
  setting showdebugoutput = !application.isProduction;

  public boolean function return_error(required string message) {
    application.flash.error(message);
    return false;
  }

  variables.router = request.router;
  variables.utility = application.utility;
  variables.between = utility.between;
  variables.ifin = utility.ifin;
  variables.safe_save = utility.safe_save;
  variables.flash = application.flash;

  if (form.keyExists('btnView')) session.user.set('view', form.btnView);
</cfscript>
