<cfscript>
  router.include('shared/blog/entries', { results: mBlog.entries(utility.paged_term_params(ben_released: true, maxrows: 10)) });
</cfscript>
