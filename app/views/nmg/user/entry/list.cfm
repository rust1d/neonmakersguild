<cfscript>
  results = mUserBlog.entries(utility.paged_term_params());
</cfscript>

<cfoutput>
  <div class='row g-3'>
    <div class='col-12 content-card'>
      <cfset router.include('user/entry/modal') />
    </div>
    <div class='col-12 content-card'>
      <div class='d-flex justify-content-between align-items-center mb-3'>
        <div class='fs-5 fw-semibold'>Post Manager</div>
        <div>
          <a href='#router.href('user/entry/edit')#' class='btn btn-sm btn-nmg me-2'><i class='fa-solid fa-fw fa-plus'></i> New Post</a>
        </div>
        #router.include('shared/partials/filter_and_page', { pagination: results.pagination })#
      </div>

      <div class='list-group list-group-flush'>
        <cfloop array='#results.rows#' item='mEntry'>
          <div class='list-group-item px-3 py-2 d-flex gap-3 align-items-center'>
            <div class='flex-grow-1'>
              <div class='fw-semibold d-flex align-items-center gap-2'>
                <a href='#router.hrefenc(page: 'user/entry/edit', benid: mEntry.benid())#' class='text-decoration-none text-dark'>
                  #mEntry.title()#
                </a>
                <cfif isDate(mEntry.ben_promoted())>
                  <i class='fa-solid fa-star text-warning' title='Front Page'></i>
                </cfif>
                <cfif mEntry.released()>
                  <i class='fa-solid fa-circle-check text-success' title='Released'></i>
                <cfelse>
                  <i class='fa-solid fa-circle-minus text-info' title='Released'></i>
                </cfif>
              </div>
              <div class='text-muted smaller'>
                Posted: #mEntry.posted()# &bull;
                #utility.plural_label(mEntry.words().len(), 'word')# &bull;
                #utility.plural_label(mEntry.image_cnt(), 'image')# &bull;
                #utility.plural_label(mEntry.views(), 'view')# &bull;
                #utility.plural_label(mEntry.comment_cnt(), 'comment')#
              </div>
            </div>
            <div>
              <a href='#router.hrefenc(page: 'user/entry/edit', benid: mEntry.benid())#' class='btn btn-sm btn-outline-secondary'>
                <i class='fa-solid fa-pencil'></i>
              </a>
            </div>
          </div>
        </cfloop>
      </div>
    </div>
  </div>
</cfoutput>
