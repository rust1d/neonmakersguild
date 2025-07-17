<cfscript>
  if (utility.isPost() && form.keyExists('post_form')) {
    mEntry = new app.services.user.Post().create(mUser);
    benid = mEntry.new_record() ? 0 : mEntry.benid();
  } else {
    benid = router.decode('benid');
    mEntry = mUserBlog.entry_find_or_create(benid);
  }
  router.include('shared/user/entry/post');
</cfscript>
