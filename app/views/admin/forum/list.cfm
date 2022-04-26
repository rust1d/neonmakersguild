<cfscript>
  mForums = new app.models.Forums().where();
</cfscript>

<cfoutput>
  <div class='card'>
    <div class='card-header bg-nmg'>
      <div class='row'>
        <div class='col fs-5'>Forums</div>
        <div class='col-auto'>
          <div class='input-group input-group-sm'>
            <a href='#router.href('forum/edit')#' class='btn btn-sm btn-nmg' title='Add'>
              <i class='fal fa-plus'></i>
            </a>
          </div>
        </div>
      </div>
    </div>
    <div class='card-body table-responsive'>
      <table class='table table-sm table-nmg'>
        <thead>
          <tr>
            <th scope='col'><a href='#router.href('forum/edit')#' class='btn btn-sm btn-nmg'><i class='fal fa-plus'></i></a></th>
            <th scope='col'>Name</th>
            <th scope='col'>Description</th>
            <th scope='col'>Active</th>
            <th scope='col'>Posts</th>
          </tr>
        </thead>
        <tbody>
          <cfloop array='#mForums#' item='mForum'>
            <tr>
              <th scope='row'>
                <a href='#router.hrefenc(page: 'forum/edit', foid: mForum.foid())#' class='btn btn-sm btn-nmg'>
                  <i class='fal fa-pencil'></i>
                </a>
              </th>
              <td>#mForum.name()#</td>
              <td>#mForum.description()#</td>
              <td class='text-center'><i class='fa-solid #ifin(mForum.active(), 'fa-toggle-on','fa-toggle-off')# fa-xl')></i></td>
              <td>#mForum.messages()#</td>
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
    </ul>
  </div>
</cfoutput>
