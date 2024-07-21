<cfscript>
  results = mBlog.textblocks(utility.paged_term_params());
</cfscript>

<cfoutput>
  <div class='card'>
    <div class='card-header bg-nmg'>
      <div class='row'>
        <div class='col-auto'>
          <div class='input-group input-group-sm'>
            <a href='#router.href('blog/block/edit')#' class='btn btn-sm btn-nmg' title='Add'>
              <i class='fa-solid fa-fw fa-plus'></i>
            </a>
          </div>
        </div>
        <div class='col fs-5'>Content Blocks</div>
        #router.include('shared/partials/filter_and_page', { pagination: results.pagination })#
      </div>
    </div>
    <div class='card-body table-responsive'>
      <table class='table table-sm table-nmg'>
        <thead>
          <tr>
            <th scope='col'><a href='#router.href('blog/block/edit')#' class='btn btn-sm btn-nmg'><i class='fa-solid fa-fw fa-plus'></i></a></th>
            <th scope='col'>Label</th>
            <th scope='col'>Preview</th>
            <th scope='col'>Words</th>
          </tr>
        </thead>
        <tbody>
          <cfloop array='#results.rows#' item='mTextBlock'>
            <tr>
              <th scope='row'>
                <a href='#router.hrefenc(page: 'blog/block/edit', btbid: mTextBlock.btbid())#' class='btn btn-sm btn-nmg'>
                  <i class='fa-solid fa-fw fa-pencil'></i>
                </a>
              </th>
              <td>#mTextBlock.label()#</td>
              <td>#mTextBlock.preview()#</td>
              <td class='text-end'>#mTextBlock.words().len()#</td>
            </tr>
          </cfloop>
        </tbody>
      </table>
    </div>
  </div>

  <div class='alert-info border rounded mt-3 p-3'>
    Tips:
    <ul>
      <li>Create a <code>forums</code> content block to display at the top of the forums list page.</li>
      <li>Create a <code>forum-<span class='fst-italic'>forum_alias</span></code> content block to display at the top of a forum thread page.</li>
      <li>Create <code>sidebar-*</code> content blocks to display main side order. They will display in alphabetical order by alias.</li>
      <li>Create a <code>login</code> content block to display at the top of the login page.</li>
    </ul>
  </div>
</cfoutput>
