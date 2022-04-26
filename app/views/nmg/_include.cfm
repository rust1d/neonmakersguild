<cfscript>
  variables.mUserBlog = new app.services.user.Blog(url.blogid ?: 1);
  variables.mBlog = new app.services.user.Blog(1);
</cfscript>
