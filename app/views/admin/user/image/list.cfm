<cfscript>
  usid = router.decode('usid');
  if (!usid) router.redirect('user/list');

  router.include('shared/user/image/list', { mBlog: new app.services.user.Blog(usid) });
</cfscript>
