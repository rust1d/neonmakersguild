<cfscript>
  mBlog = new app.services.user.Blog(1);
  router.include('shared/user/image/upload', { mBlog: mBlog });
</cfscript>
