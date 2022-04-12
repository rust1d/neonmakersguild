<cfscript>
  mUsers = new app.models.Users().where();
  view = session.user.gets('view');
</cfscript>

<cfoutput>
  <section class='container'>
    <div class='row mb-3'>
      <div class='col-6'>
        <h4>Members</h4>
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
        <cfloop array='#mUsers#' item='mUser'>
          <div class='col-6 col-md-4 col-lg-3 col-xl-2'>
            <a href='#mUser.seo_link()#'>
              <img class='img-thumbnail w-100' src='#mUser.profile_image().src()#' />
            </a>
            <a href='#mUser.seo_link()#' class='btn btn-nmg btn-sm btn-outline-dark w-100 mt-1'>
              #mUser.UserProfile().firstname()# #mUser.UserProfile().lastname()#
            </a>
          </div>
        </cfloop>
      </div>
    </cfif>
  </section>
</cfoutput>
