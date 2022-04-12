<cfscript>
  usid = router.decode('usid');
  if (!usid) router.redirect('user/list');

  mBlog = new app.services.user.Blog(usid);
  router.include('shared/user/image/list', { mImages: mBlog.images() });
</cfscript>
