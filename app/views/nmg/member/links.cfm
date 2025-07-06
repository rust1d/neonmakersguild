<cfscript>
  params = utility.paged_term_params(bli_type: 'bookmark');
  results = mUserBlog.links(params);
</cfscript>

<cfoutput>
  <div class='col-12 content-card'>
    <cfif !results.pagination.one_page>
      <div class='row border-top-0 pt-2 pb-0'>
        #router.include('shared/partials/filter_and_page', { pagination: results.pagination })#
      </div>
    </cfif>

    <ul>
      <cfloop array='#results.rows#' item='mLink'>
        <li class='mb-2'>
          <a class='fs-6' href='#mLink.url()#' data-link='#mLink.datadash()#' target='_blank'>#mLink.title()#</a>
          <cfif mLink.description().len()>
            <div class='small'>#mLink.description()#</div>
          </cfif>
        </li>
      </cfloop>
    </ul>

    <div class='border-top pt-3'>
      <div class='row align-items-center'>
        #router.include('shared/partials/filter_and_page', { pagination: results.pagination, footer: true })#
      </div>
    </div>
  </div>
</cfoutput>
