<cfscript>
  arrCategories = mBlog.Categories();
</cfscript>

<cfoutput>
  <div class='card'>
    <div class='card-header btn-nmg'>
      <div class='row'>
        <div class='col fs-5'>Categories</div>
        <cfif mBlog.isAuthorized('AddCategory')>
          <div class='col-auto'>
            <a href='#router.href('blog/category/edit')#' class='btn btn-sm btn-nmg' title='Add'>
              <i class='fal fa-plus'></i>
            </a>
          </div>
        </cfif>
        #router.include('shared/partials/view_and_filter', { viewer: false })#
      </div>
    </div>
    <div class='card-body'>
      <table class='table table-nmg'>
        <thead>
          <tr>
            <th scope='col'>
              <cfif mBlog.isAuthorized('AddCategory')>
                <a href='#router.href('blog/category/edit')#' class='btn btn-sm btn-nmg'><i class='fal fa-plus'></i></a>
              </cfif>
            </th>
            <th scope='col'>Category</th>
            <th scope='col'>Entries</th>
          </tr>
        </thead>
        <tbody>
          <cfloop array='#arrCategories#' item='mCategory'>
            <tr>
              <th scope='row'>
                <a href='#router.hrefenc(page: 'blog/category/edit', bcaid: mCategory.bcaid())#' class='btn btn-sm btn-nmg'>
                  <i class='fal fa-pencil'></i>
                </a>
              </th>
              <td>#mCategory.category()#</td>
              <td>#mCategory.entryCnt()#</td>
            </tr>
          </cfloop>
        </tbody>
      </table>
    </div>
  </div>
</cfoutput>
