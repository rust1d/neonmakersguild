<cfscript>
  benid = router.decode('benid');
  mEntry = mBlog.entry_find_or_create(benid);

  router.include('shared/user/entry/post');
</cfscript>
