<cfscript>
  mTextBlocks = mBlog.textblocks();
</cfscript>

<cfoutput>
  <div class='card'>
    <div class='card-header bg-nmg'>
      <div class='row'>
        <div class='col fs-5'>Content Blocks</div>
        <div class='col-auto'>
          <div class='input-group input-group-sm'>
            <a href='#router.href('blog/block/edit')#' class='btn btn-sm btn-nmg' title='Add'>
              <i class='fal fa-plus'></i>
            </a>
          </div>
        </div>
        #router.include('shared/partials/view_and_filter', { viewer: false })#
      </div>
    </div>
    <div class='card-body table-responsive'>
      <table class='table table-sm table-nmg'>
        <thead>
          <tr>
            <th scope='col'><a href='#router.href('blog/block/edit')#' class='btn btn-sm btn-nmg'><i class='fal fa-plus'></i></a></th>
            <th scope='col'>Label</th>
            <th scope='col'>Preview</th>
            <th scope='col'>Words</th>
          </tr>
        </thead>
        <tbody>
          <cfloop array='#mTextBlocks#' item='mTextBlock'>
            <tr>
              <th scope='row'>
                <a href='#router.hrefenc(page: 'blog/block/edit', btbid: mTextBlock.btbid())#' class='btn btn-sm btn-nmg'>
                  <i class='fal fa-pencil'></i>
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
</cfoutput>
