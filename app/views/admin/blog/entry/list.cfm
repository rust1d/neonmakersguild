<!---
TODO:
release entry
sort entries
paging
filtering
--->
<cfscript>
  mEntries = mBlog.entries();
</cfscript>

<cfoutput>
  <div class='card'>
    <div class='card-header btn-nmg'>
      <div class='row'>
        <div class='col fs-5'>Entries</div>
        <div class='col-auto'>
          <div class='input-group input-group-sm'>
            <a href='#router.href('blog/entry/edit')#' class='btn btn-sm btn-nmg' title='Add'>
              <i class='fal fa-plus'></i>
            </a>
          </div>
        </div>
        #router.include('shared/partials/view_and_filter', { viewer: false })#
      </div>
    </div>
    <div class='card-body'>
      <table class='table'>
        <thead>
          <tr>
            <th scope='col'><a href='#router.href('blog/entry/edit')#' class='btn btn-sm btn-nmg'><i class='fal fa-plus'></i></a></th>
            <th scope='col'>Title</th>
            <th scope='col'>Released</th>
            <th scope='col'>Posted</th>
            <th scope='col'>Words</th>
          </tr>
        </thead>
        <tbody>
          <cfloop array='#mEntries#' item='mEntry'>
            <tr>
              <th scope='row'>
                <a href='#router.hrefenc(page: 'blog/entry/edit', benid: mEntry.benid())#' class='btn btn-sm btn-nmg'>
                  <i class='fal fa-pencil'></i>
                </a>
              </th>
              <td>#mEntry.title()#</td>
              <td class='text-center'><i class='fa-solid #ifin(mEntry.released(), 'fa-toggle-on','fa-toggle-off')# fa-xl')></i></td>
              <td nowrap>#mEntry.posted()#</td>
              <td class='text-end'>#mEntry.words().len()#</td>
            </tr>
          </cfloop>
        </tbody>
      </table>
    </div>
  </div>
</cfoutput>
