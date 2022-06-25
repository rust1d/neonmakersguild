<cfscript>
  form.maxrows = 23;
  locals.mBlog = mBlog;
  // router.include('shared/user/library/list', { mBlog: mBlog });

  locals.view = session.user.view();
  locals.dest = (locals.mBlog.id()==1 && session.site.isA('admin')) ? 'blog' : 'user';
  locals.results = locals.mBlog.documents(utility.paged_term_params());
</cfscript>

<cfoutput>
  <div class='card'>
    <div class='card-header bg-nmg'>
      <div class='row'>
        <div class='col-auto'>
          <div class='input-group input-group-sm'>
            <a href='#router.href('#locals.dest#/library/edit')#' class='btn btn-sm btn-nmg' title='Add document'>
              <i class='fal fa-plus'></i>
            </a>
          </div>
        </div>
        <div class='col fs-5'>Documents</div>
        #router.include('shared/partials/filter_and_page', { pagination: locals.results.pagination })#
        #router.include('shared/partials/viewer')#
      </div>
    </div>
    <div class='card-body table-responsive'>
      <table class='table table-sm table-nmg'>
        <thead>
          <tr>
            <th scope='col'><a href='#router.href('#locals.dest#/library/edit')#' class='btn btn-sm btn-nmg'><i class='fal fa-plus'></i></a></th>
            <th scope='col'>Filename</th>
            <th scope='col'>Description</th>
            <th scope='col'>Size</th>
          </tr>
        </thead>
        <tbody>
          <cfloop array='#locals.results.rows#' item='locals.mDocument' index='idx'>
            <tr>
              <th scope='row'>
                <a href='#router.hrefenc(page: '#locals.dest#/library/edit', docid: locals.mDocument.docid())#' class='btn btn-sm btn-nmg'>
                  <i class='fal fa-pencil'></i>
                </a>
              </th>
              <td>#locals.mDocument.filename()#</td>
              <td>#locals.mDocument.preview()#</td>
              <td class='text-end'>#locals.mDocument.size_mb()#</td>
            </tr>
          </cfloop>
        </tbody>
      </table>
    </div>
  </div>
</cfoutput>
