<cfscript>
  mdl = new app.models.Users();
  params = { maxrows: 29 }
  mUsers = mdl.where(utility.paged_term_params(params));
  pagination = mdl.pagination();

  view = session.user.view();
</cfscript>

<cfoutput>
  <div class='card'>
    <div class='card-header bg-nmg'>
      <div class='row'>
        <div class='col-auto'>
          <div class='input-group input-group-sm'>
            <a href='#router.href('user/edit')#' class='btn btn-sm btn-nmg' title='Add'>
              <i class='fal fa-plus'></i>
            </a>
          </div>
        </div>
        <div class='col fs-5'>Users</div>
        #router.include('shared/partials/filter_and_page', { pagination: pagination })#
        #router.include('shared/partials/viewer')#
      </div>
    </div>
    <div class='card-body'>
      <cfif view=='list'>
        <cfloop array='#mUsers#' item='mUser'>
          <div class='row my-3'>
            <div class='col-2'>
              <a href='#router.hrefenc(page: 'user/edit', usid: mUser.usid())#'>
                <img class='img-thumbnail w-auto' src='#mUser.profile_image().src()#' />
              </a>
            </div>
            <div class='col-10'>
              <div class='lead'>
                <a href='#router.hrefenc(page: 'user/edit', usid: mUser.usid())#'>
                  <i class='fal fa-pencil'></i> #mUser.user()#
                </a>
                <div>#mUser.UserProfile().firstname()# #mUser.UserProfile().lastname()#</div>
                <div>#mUser.UserProfile().location()#</div>
              </div>
            </div>
          </div>
        </cfloop>
      <cfelse>
        <div class='row g-4'>
          <div class='col-6 col-md-4 col-lg-3 col-xl-2'>
            <a href='#router.href('user/edit')#'>
              <img class='img-thumbnail w-100' src='#application.urls.cdn#/assets/images/image_new.png' />
            </a>
            <a href='#router.href('user/edit')#' class='btn btn-sm btn-nmg w-100 mt-1'>
              <i class='fal fa-plus'></i>
              Add User
            </a>
          </div>
          <cfloop array='#mUsers#' item='mUser'>
            <div class='col-6 col-md-4 col-lg-3 col-xl-2'>
              <a href='#router.hrefenc(page: 'user/edit', usid: mUser.usid())#'>
                <img class='img-thumbnail w-100 pb-1' src='#mUser.profile_image().src()#' />
              </a>
              <a href='#router.hrefenc(page: 'user/edit', usid: mUser.usid())#' class='btn btn-sm btn-nmg w-100 mt-1'>
                <i class='fal fa-pencil'></i>
                #mUser.user()#
              </a>
            </div>
          </cfloop>
        </div>
      </cfif>
    </div>
    <div class='card-footer bg-nmg'>
      <div class='row align-items-center'>
        #router.include('shared/partials/filter_and_page', { pagination: pagination, footer: true })#
      </div>
    </div>
  </div>
</cfoutput>
