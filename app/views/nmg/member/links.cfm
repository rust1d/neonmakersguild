<cfscript>
  params = utility.paged_term_params(bli_type: 'bookmark');
  results = mUserBlog.links(params);
</cfscript>

<cfoutput>
  <div class='card-body border-top-0 py-2'>
    <div class='row'>
      #router.include('shared/partials/filter_and_page', { pagination: results.pagination })#
    </div>
  </div>
  <div class='card-body'>
    <div class='row'>
      <div class='col-12'>
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
      </div>
    </div>
  </div>
  <div class='card-footer bg-nmg-light'>
    <div class='row align-items-center'>
      #router.include('shared/partials/filter_and_page', { pagination: results.pagination, footer: true })#
    </div>
  </div>
</cfoutput>
