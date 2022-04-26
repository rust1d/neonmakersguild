<cfscript>
  benid = router.decode('benid');
  mEntry = mUserBlog.entry_find_or_create(benid);

  router.include('shared/user/entry/edit');
</cfscript>
