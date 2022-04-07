<cfscript>
  mUser = new app.models.user(us_email: 'rust1d@usa.net', password: 'Pi55p00r!');
  mUser.safe_save();
  writeDump(muser.errors());
</cfscript>