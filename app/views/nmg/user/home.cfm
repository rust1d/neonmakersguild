<cfscript>
  url.usid = session.user.encoded_key();
  router.include('member/view', { mUser: mUser });
</cfscript>
