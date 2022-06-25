<cfscript>
  arrTags = mBlog.Tags();
</cfscript>

<cfoutput>
  <div class='card'>
    <div class='card-header bg-nmg'>
      <div class='row'>
        <div class='col fs-5'>Tags</div>
        <div class='col-auto'>
          <a href='#router.href('blog/tag/edit')#' class='btn btn-sm btn-nmg' title='Add'>
            <i class='fal fa-plus'></i>
          </a>
        </div>
        #router.include('shared/partials/filter_and_page')#
      </div>
    </div>
    <div class='card-body table-responsive'>
      <table class='table table-sm table-nmg'>
        <thead>
          <tr>
            <th scope='col'>
              <a href='#router.href('blog/tag/edit')#' class='btn btn-sm btn-nmg'><i class='fal fa-plus'></i></a>
            </th>
            <th scope='col'>Tag</th>
            <th scope='col'>Documents</th>
          </tr>
        </thead>
        <tbody>
          <cfloop array='#arrTags#' item='mTag'>
            <tr>
              <th scope='row'>
                <a href='#router.hrefenc(page: 'blog/tag/edit', tagid: mTag.tagid())#' class='btn btn-sm btn-nmg'>
                  <i class='fal fa-pencil'></i>
                </a>
              </th>
              <td>#mTag.tag()#</td>
              <td>#mTag.doc_count()#</td>
            </tr>
          </cfloop>
        </tbody>
      </table>
    </div>
  </div>
</cfoutput>
