<cfscript>
  session.user.requireLogin('Users');
  if (!session.user.get_admin()) router.redirect('?ref=nmg');

</cfscript>
