<cfscript>
  mUsers = new app.models.Users().where();
  view = session.user.view();
</cfscript>

<cfoutput>
  <section class='container'>
    <div class='card'>
      <div class='card-header bg-nmg'>
        <div class='row g-2'>
          <div class='col fs-5'>Members</div>
          #router.include('shared/partials/view_and_filter')#
        </div>
      </div>
      <div class='card-body'>
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
      </div>
    </div>
  </section>
</cfoutput>
