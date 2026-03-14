<cfscript>
  results = mUserBlog.links(utility.paged_term_params());
</cfscript>

<cfoutput>
  <cfif results.rows.len()>
    <a class='btn btn-icon btn-icon-link me-1' data-bs-toggle='offcanvas' href='##memberLinks' role='button' aria-controls='memberLinks' title='#mUser.user()#&rsquo;s Links'>
      <i class='fa-brands fa-yelp fa-lg rotate-x'></i>
    </a>
    <div class='offcanvas offcanvas-end' tabindex='-1' id='memberLinks' aria-labelledby='memberLinksLabel'>
      <div class='offcanvas-header bg-nmg-dark text-white'>
        <h5 class='offcanvas-title text-marker' id='memberLinksLabel'>#mUser.user()#&rsquo;s Links</h5>
        <button type='button' class='btn-close btn-close-white' data-bs-dismiss='offcanvas' aria-label='Close'></button>
      </div>
      <div class='offcanvas-body d-grid gap-2 p-3'>
        <cfloop array='#results.rows#' item='mLink'>
          <a class='btn btn-nmg d-flex align-items-center gap-2 p-2 rounded' href='#mLink.url()#' data-link='#mLink.datadash()#' target='_blank'>
            <span>#mLink.icon('fa-lg')#</span>
            <span class='flex-grow-1'>#mLink.title()#</span>
            <i class='fa-solid fa-arrow-up-right-from-square small'></i>
          </a>
          <cfif mLink.description().len()>
            <div class='smaller text-secondary px-2 mt-n1 mb-1'>#mLink.description()#</div>
          </cfif>
        </cfloop>
      </div>
    </div>
  </cfif>
</cfoutput>
