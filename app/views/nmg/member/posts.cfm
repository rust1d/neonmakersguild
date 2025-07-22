<cfscript>
  results = mUserBlog.entries(utility.paged_term_params(ben_released: true, maxrows: 5));
  section = 'user';
</cfscript>

<cfoutput>
  #router.include('shared/blog/entries', { results: results, section: section })#
</cfoutput>
