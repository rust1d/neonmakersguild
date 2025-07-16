<cfscript>
  results = mUserBlog.links(utility.paged_term_params());
</cfscript>

<cfoutput>
  <cfif results.rows.len()>
    <span class='dropdown-center me-1'>
      <a class='btn btn-icon btn-icon-link' data-bs-toggle='dropdown' aria-expanded='false' title='#mUser.user()#&rsquo;s Links'>
        <i class='fa-brands fa-yelp fa-lg rotate-x'></i>
      </a>
      <div class='dropdown-menu content-card member-links p-0'>
        <div class='d-flex justify-content-between align-items-start border-bottom p-2'>
          <span class='fw-semibold'>#mUser.user()#&rsquo;s Links</span>
          <button type='button' class='btn-close' data-bs-dismiss='dropdown' aria-label='Close'></button>
        </div>

        <div class='d-grid mt-2 member-links-body'>
          <cfloop array='#results.rows#' item='mLink'>
            <div class='p-2'>
              <a class='btn btn-nmg btn-lg d-flex align-items-center justify-content-between w-100 px-1 p-0 rounded-pill' href='#mLink.url()#' data-link='#mLink.datadash()#' target='_blank'>
                <span class='me-auto'>#mLink.icon('fa-lg')#</span>
                <span class='mx-auto text-center flex-grow-1'>#mLink.title()#</span>
              </a>
              <cfif mLink.description().len()>
                <div class='smaller px-3 mt-1'>#mLink.description()#</div>
              </cfif>
            </div>
          </cfloop>
        </div>
      </div>
    </span>
  </cfif>
</cfoutput>
