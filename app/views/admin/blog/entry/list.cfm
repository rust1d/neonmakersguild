<cfscript>
  mEntries = mBlog.entries();
  router.include('shared/user/entry/list', { mBlog: mBlog });
</cfscript>
