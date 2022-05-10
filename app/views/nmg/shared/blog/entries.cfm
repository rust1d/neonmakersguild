<cfoutput>
  <div class='row g-3'>
    <cfloop array='#locals.results.rows#' item='locals.mEntry' index='locals.idx'>
      <div class='col-12'>
        #router.include('shared/blog/entry', { mEntry: locals.mEntry, fold: !locals.results.pagination.first || locals.idx gt 2 })#
      </div>
    </cfloop>
    <cfif !locals.results.pagination.one_page>
      <div class='col-6 text-center text-uppercase'>
        <cfif !locals.results.pagination.first>
          <a href='#utility.page_url_prev(locals.results.pagination, '/blog')#'><i class='fa-solid fa-xl fa-caret-left'></i> Newer Posts</a>
        </cfif>
      </div>
      <div class='col-6 text-center text-uppercase'>
        <cfif !locals.results.pagination.last>
          <a href='#utility.page_url_next(locals.results.pagination, '/blog')#'>Older posts <i class='fa-solid fa-xl fa-caret-right'></i></a>
        </cfif>
      </div>
    </cfif>
  </div>
</cfoutput>
