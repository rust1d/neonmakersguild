<cfscript>
  locals.view = session.user.view();
  locals.dest = (mBlog.id()==1 && session.site.isA('admin')) ? 'blog' : 'user';
</cfscript>

<cfoutput>
  <div class='card'>
    <div class='card-header bg-nmg'>
      <div class='row'>
        <div class='col fs-5'>Links</div>
        <div class='col-auto'>
          <a href='#router.href('#locals.dest#/link/edit')#' class='btn btn-sm btn-nmg' title='Add'>
            <i class='fal fa-plus'></i>
          </a>
        </div>
        #router.include('shared/partials/view_and_filter', { viewer: false })#
      </div>
    </div>
    <div class='card-body table-responsive'>
      <table class='table table-sm table-nmg'>
        <thead>
          <tr>
            <th scope='col'><a href='#router.href('#locals.dest#/link/edit')#' class='btn btn-sm btn-nmg'><i class='fal fa-plus'></i></a></th>
            <th scope='col'>Type</th>
            <th scope='col'>Title</th>
            <th scope='col' class='d-none d-md-table-cell'>Url</th>
          </tr>
        </thead>
        <tbody>
          <cfloop array='#locals.mLinks#' item='locals.mLink'>
            <tr>
              <th scope='row' nowrap>
                <a href='#router.hrefenc(page: '#locals.dest#/link/edit', bliid: locals.mLink.bliid())#' class='btn btn-sm btn-nmg'>
                  <i class='fal fa-pencil'></i>
                </a>
              </th>
              <td><span class='ps-2'>#locals.mLink.icon_link('2xl')#</span></td>
              <td>#locals.mLink.title()#</td>
              <td class='d-none d-md-table-cell small'>#locals.mLink.url()#</td>
            </tr>
          </cfloop>
        </tbody>
      </table>
    </div>
  </div>
</cfoutput>
