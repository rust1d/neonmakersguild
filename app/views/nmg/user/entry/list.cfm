<cfscript>
  mEntries = new app.models.BlogEntries().where(ben_usid: mUser.usid(), mBlog: mBlog, maxrows: 25);

  router.include('shared/user/entry/list', { mBlog: mBlog });
</cfscript>
