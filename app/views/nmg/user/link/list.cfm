<cfscript>
  results = mUserBlog.links(utility.paged_term_params());
</cfscript>

<cfoutput>
  <div class='row g-3'>
    <div class='col-12 text-center content-card bg-nmg-dark text-white py-4'>
      <div class='fs-2 text-marker'>Link Manager</div>
    </div>
    <div class='col-12 content-card'>
      <div class='row g-2 justify-content-end align-items-center pb-3'>
        <div class='col-auto me-auto'>
          <a href='#router.href('user/link/edit')#' class='btn btn-sm btn-nmg rounded-pill px-3'><i class='fa-solid fa-fw fa-plus'></i> New Link</a>
        </div>
        #router.include('shared/partials/filter_and_page', { pagination: results.pagination })#
      </div>
      <table class='table table-sm table-nmg'>
        <thead>
          <tr class='align-middle smaller'>
            <th scope='col'><a href='#router.href('user/link/edit')#' class='btn btn-sm btn-nmg rounded-circle px-2'><i class='fa-solid fa-fw fa-plus'></i></a></th>
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
                <a href='#router.hrefenc(page: 'user/link/edit', bliid: mLink.bliid())#' class='btn btn-sm btn-nmg rounded-circle px-2'>
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
