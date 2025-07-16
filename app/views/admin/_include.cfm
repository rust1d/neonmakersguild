<cfscript>
  session.user.requireLogin('Users');
  if (!session.user.get_admin()) router.redirect('?ref=nmg');

  variables.mBlog = new app.services.user.Blog(1);
</cfscript>
