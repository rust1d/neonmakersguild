<cfscript>
  mUsers = new app.models.Users().where();
  view = session.user.gets('view');
</cfscript>

<cfoutput>
  <section class='container'>
    <div class='row mb-3'>
      <div class='col-6'>
        <h4>Users</h4>
      </div>
      <div class='col-6 text-end'>
        <form method='post'>
          <div class='btn-group' role='group'>
            <button type='#ifin(view=='grid', 'button', 'submit')#' name='btnView' value='grid' class='btn btn-nmg'><i class='#ifin(view=='grid', 'text-warning')# fad fa-th '></i></button>
            <button type='#ifin(view!='grid', 'button', 'submit')#' name='btnView' value='list' class='btn btn-nmg'><i class='#ifin(view!='grid', 'text-warning')# fad fa-list'></i></button>
          </div>
        </form>
      </div>
    </div>
    <cfif view=='list'>
      <cfloop array='#mUsers#' item='mUser'>
        <div class='row p-2 my-2 border'>
          <div class='col-2'>
            <img class='img-thumbnail w-50' src='#mUser.profile_image().src()#' />
          </div>
          <div class='col-2'>
            #mUser.UserProfile().firstname()# #mUser.UserProfile().lastname()#
          </div>
          <div class='col-2'>
            #mUser.user()#
          </div>
          <div class='col-2'>
            #mUser.UserProfile().location()#
          </div>
        </div>
      </cfloop>
    <cfelse>
      <div class='row g-4'>
        <div class='col-6 col-md-4 col-lg-3 col-xl-2'>
          <a href='#router.href('user/edit')#'>
            <img class='img-thumbnail w-100' src='/assets/images/image_new.png' />
          </a>
          <a href='#router.href('user/edit')#' class='btn btn-nmg btn-sm btn-outline-dark w-100 mt-1'>
            <i class='fal fa-plus'></i>
            Add User
          </a>
        </div>
        <cfloop array='#mUsers#' item='mUser'>
          <div class='col-6 col-md-4 col-lg-3 col-xl-2'>
            <a href='#router.hrefenc(page: 'user/edit', usid: mUser.usid())#'>
              <img class='img-thumbnail w-100 pb-1' src='#mUser.profile_image().src()#' />
            </a>
            <a href='#router.hrefenc(page: 'user/edit', usid: mUser.usid())#' class='btn btn-nmg btn-sm btn-outline-dark w-100 mt-1'>
              <i class='fal fa-pencil'></i>
              #mUser.user()#
            </a>
          </div>
        </cfloop>
      </div>
    </cfif>
  </section>
</cfoutput>
