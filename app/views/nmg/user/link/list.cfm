<cfscript>
  results = mUserBlog.links(utility.paged_term_params());
</cfscript>

<cfoutput>
  <div class='row g-3'>
    <div class='col-12 content-card'>
      <div class='d-flex justify-content-between align-items-center mb-3'>
        <div class='fs-5 fw-semibold'>Link Manager</div>
        <div>
          <a href='#router.href('user/link/edit')#' class='btn btn-sm btn-nmg me-2'><i class='fa-solid fa-fw fa-plus'></i> New Link</a>
        </div>
        #router.include('shared/partials/filter_and_page', { pagination: results.pagination })#
      </div>
      <table class='table table-sm table-nmg'>
        <thead>
          <tr class='align-middle smaller'>
            <th scope='col'><a href='#router.href('user/link/edit')#' class='btn btn-sm btn-nmg'><i class='fa-solid fa-fw fa-plus'></i></a></th>
            <th scope='col'>Type</th>
            <th scope='col'>Title</th>
            <th scope='col' class='d-none d-md-table-cell'>Url</th>
            <th scope='col'>Clicks</th>
          </tr>
        </thead>
        <tbody>
          <cfloop array='#results.rows#' item='mLink'>
            <tr>
              <th scope='row' nowrap>
                <a href='#router.hrefenc(page: 'user/link/edit', bliid: mLink.bliid())#' class='btn btn-sm btn-nmg'>
                  <i class='fa-solid fa-fw fa-pencil'></i>
                </a>
              </th>
              <td nowrap>#mLink.icon('xl')#</td>
              <td nowrap>#mLink.title()#</td>
              <td class='d-none d-md-table-cell small'>#mLink.url()#</td>
              <td>#mLink.clicks()#</td>
            </tr>
          </cfloop>
        </tbody>
      </table>
    </div>
  </div>
</cfoutput>
