<cfscript>
  mBlog = new app.services.user.Blog(1);
  router.include('shared/user/image/list', { mImages: mBlog.images() });
</cfscript>
