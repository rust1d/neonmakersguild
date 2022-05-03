<cfscript>
  mPages = mBlog.pages();
</cfscript>

<cfoutput>
  <div class='card'>
    <div class='card-header bg-nmg'>
      <div class='row'>
        <div class='col fs-5'>Pages</div>
        <div class='col-auto'>
          <div class='input-group input-group-sm'>
            <a href='#router.href('blog/page/edit')#' class='btn btn-sm btn-nmg' title='Add'>
              <i class='fal fa-plus'></i>
            </a>
          </div>
        </div>
        #router.include('shared/partials/filter_and_page')#
      </div>
    </div>
    <div class='card-body table-responsive'>
      <table class='table table-sm table-nmg'>
        <thead>
          <tr>
            <th scope='col'><a href='#router.href('blog/page/edit')#' class='btn btn-sm btn-nmg'><i class='fal fa-plus'></i></a></th>
            <th scope='col'>Title</th>
            <th scope='col'>Alias</th>
            <th scope='col'>Preview</th>
            <th scope='col'>Words</th>
          </tr>
        </thead>
        <tbody>
          <cfloop array='#mPages#' item='mPage'>
            <tr>
              <th scope='row'>
                <a href='#router.hrefenc(page: 'blog/page/edit', bpaid: mPage.bpaid())#' class='btn btn-sm btn-nmg'>
                  <i class='fal fa-pencil'></i>
                </a>
              </th>
              <td>#mPage.title()#</td>
              <td>#mPage.alias()#</td>
              <td>#mPage.preview()#</td>
              <td class='text-end'>#mPage.words().len()#</td>
            </tr>
          </cfloop>
        </tbody>
      </table>
    </div>
  </div>
</cfoutput>
