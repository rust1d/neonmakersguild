<cfscript>
  locals.params = utility.paged_term_params(bli_type: url.slug);
  locals.results = mBlog.links(locals.params);
</cfscript>

<cfoutput>
  <div class='card'>
    <div class='card-header bg-nmg'>
      <div class='row align-items-center'>
        <div class='col-auto fs-6'>#locals.mPage.title()#</div>
        #router.include('shared/partials/filter_and_page', { pagination: locals.results.pagination })#
      </div>
    </div>
    <div class='card-body'>
      <div class='row'>
        <div class='col-12'>
          <ul>
            <cfloop array='#locals.results.rows#' item='locals.mLink'>
              <li class='mb-2' title='Added #locals.mLink.dla().format('mm/dd/yyyy')#'>
                <a class='fs-6' href='#locals.mLink.url()#' data-link='#locals.mLink.datadash()#' target='_blank'>#locals.mLink.title()#</a>
                <cfif locals.mLink.recent()><span class='float-end badge bg-warning'>new!</span></cfif>
                <cfif locals.mLink.description().len()>
                  <div class='small'>#locals.mLink.description()#</div>
                </cfif>
              </li>
            </cfloop>
          </ul>
        </div>
      </div>
    </div>
    <div class='card-footer bg-nmg'>
      <div class='row align-items-center'>
        #router.include('shared/partials/filter_and_page', { pagination: locals.results.pagination, footer: true })#
      </div>
    </div>
  </div>
</cfoutput>
