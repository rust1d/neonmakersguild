<cfscript>
  locals.params = utility.paged_term_params(bli_type: url.slug);
  locals.results = mBlog.links(locals.params);
</cfscript>

<cfoutput>
  <div class='card border-0 shadow-sm'>
    <div class='card-header bg-white'>
      <div class='row align-items-center'>
        #router.include('shared/partials/filter_and_page', { pagination: locals.results.pagination })#
      </div>
    </div>
    <div class='card-body'>
      <cfloop array='#locals.results.rows#' item='locals.mLink'>
        <div class='content-card hover-lift mb-2'>
          <div class='d-flex justify-content-between align-items-start'>
            <div>
              <a class='fs-6 fw-semibold' href='#locals.mLink.url()#' data-link='#locals.mLink.datadash()#' target='_blank'>
                #locals.mLink.title()# <i class='fa-solid fa-arrow-up-right-from-square smaller ms-1'></i>
              </a>
              <cfif locals.mLink.description().len()>
                <div class='small mt-1'>#locals.mLink.description()#</div>
              </cfif>
            </div>
            <cfif locals.mLink.recent()>
              <span class='badge bg-warning'>new!</span>
            </cfif>
          </div>
        </div>
      </cfloop>
    </div>
    <div class='card-footer bg-nmg-dark'>
      <div class='row align-items-center'>
        #router.include('shared/partials/filter_and_page', { pagination: locals.results.pagination, footer: true })#
      </div>
    </div>
  </div>
</cfoutput>
