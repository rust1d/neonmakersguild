<cfscript>
  mBlog = new app.services.user.Blog(1);
  router.include('shared/user/link/list', { mLinks: mBlog.links() });
</cfscript>
