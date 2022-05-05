<cfscript>
  locals.dest = (locals.mBlog.id()==1 && session.site.isA('admin')) ? 'blog' : 'user';
  locals.results = locals.mBlog.links(utility.paged_term_params());
</cfscript>

<cfoutput>
  <div class='card'>
    <div class='card-header bg-nmg'>
      <div class='row align-items-center'>
        <div class='col-auto fs-6'>Links</div>
        #router.include('shared/partials/filter_and_page', { pagination: locals.results.pagination })#
      </div>
    </div>
    <div class='card-body table-responsive'>
      <table class='table table-sm table-nmg'>
        <thead>
          <tr class='align-middle'>
            <th scope='col'><a href='#router.href('#locals.dest#/link/edit')#' class='btn btn-sm btn-nmg'><i class='fal fa-plus'></i></a></th>
            <th scope='col'>Type</th>
            <th scope='col'>Title</th>
            <th scope='col' class='d-none d-md-table-cell'>Url</th>
            <th scope='col'>Clicks</th>
          </tr>
        </thead>
        <tbody>
          <cfloop array='#locals.results.rows#' item='locals.mLink'>
            <tr>
              <th scope='row' nowrap>
                <a href='#router.hrefenc(page: '#locals.dest#/link/edit', bliid: locals.mLink.bliid())#' class='btn btn-sm btn-nmg'>
                  <i class='fal fa-pencil'></i>
                </a>
              </th>
              <td nowrap>#locals.mLink.icon('xl')#</td>
              <td nowrap>#locals.mLink.title()#</td>
              <td class='d-none d-md-table-cell small'>#locals.mLink.url()#</td>
              <td>#locals.mLink.clicks()#</td>
            </tr>
          </cfloop>
        </tbody>
      </table>
    </div>
    <div class='card-footer bg-nmg'>
      <div class='row align-items-center'>
        #router.include('shared/partials/filter_and_page', { pagination: locals.results.pagination, footer: true })#
      </div>
    </div>
  </div>
</cfoutput>
