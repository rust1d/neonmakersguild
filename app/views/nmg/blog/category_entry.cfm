<cfscript>
  mCategory = mBlog.category_find_or_create(router.decode('bcaid'));
  results = mBlog.entries(utility.paged_term_params(bca_bcaid: router.decode('bcaid'), maxrows: 10));
</cfscript>

<cfoutput>
  <div class='row g-3'>
    <div class='col-12 text-center rounded-pill p-3 bg-nmg-light'>
      <div class='fs-2'><a href='#mCategory.seo_link('post')#'>#mCategory.category()#</a></div>
      <small>Posts by Category</small>
    </div>
    <cfloop array='#results.rows#' item='mEntry' index='idx'>
      <div class='col-12'>
        #router.include('shared/blog/entry', { mEntry: mEntry, fold: true })#
      </div>
    </cfloop>
  </div>
</cfoutput>
