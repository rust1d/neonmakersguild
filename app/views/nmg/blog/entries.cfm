<cfscript>
  results = mBlog.entries(utility.paged_term_params(ben_released: true, maxrows: 10));
  results.pagination.next_href = '/blog';
  results.pagination.prev_href = results.pagination.page==2 ? '' : '/blog';
</cfscript>

<cfoutput>
  #router.include('shared/blog/entries', { results: results })#
</cfoutput>
