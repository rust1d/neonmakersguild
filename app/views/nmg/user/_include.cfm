<cfscript>
  session.user.requireLogin('Users');

  variables.mUser = session.user.model();
  variables.mProfile = mUser.UserProfile() ?: mUser.UserProfile(build: {});
</cfscript>
