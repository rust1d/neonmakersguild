<cfscript>
  results = mBlog.entries(utility.paged_term_params(ben_released: true, ben_promoted: true, maxrows: 10));
  results.pagination.next_href = '/blog';
  results.pagination.prev_href = results.pagination.page==2 ? '' : '/blog';
</cfscript>

<cfoutput>
  <div class='row g-2'>
    #router.include('shared/blog/entries', { results: results })#
  </div>
</cfoutput>
