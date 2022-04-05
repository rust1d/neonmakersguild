<cfscript>
  session.user.requireLogin('User');
  if (!session.user.get_admin()) router.redirect('?ref=nmg');
</cfscript>
