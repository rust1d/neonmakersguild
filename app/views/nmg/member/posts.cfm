<cfscript>
  params = utility.paged_term_params(maxrows: 5);
  if (!session.user.isUser(mUser.usid())) params.ben_released = true;
  results = mUserBlog.entries(params);
  section = 'user';
</cfscript>

<cfoutput>
  #router.include('shared/blog/entries', { results: results, section: section })#
</cfoutput>
