<cfscript>
  session.user.requireLogin('User');

  variables.mUser = session.user.model();
  variables.mProfile = mUser.UserProfile() ?: mUser.UserProfile(build: {});
</cfscript>
