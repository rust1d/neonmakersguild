<cfscript>
  mdl = new app.models.Users();
  params = { isdeleted: 0, maxrows: 24 }
  mUsers = mdl.where(utility.paged_term_params(params));
  pagination = mdl.pagination();
  view = session.user.view();
</cfscript>

<cfoutput>
  <div class='row g-3'>
    <div class='col-12'>
      <div class='card'>
        <div class='card-header bg-nmg'>
          <div class='row'>
            <div class='col fs-5'>Members</div>
            #router.include('shared/partials/filter_and_page', { pagination: pagination })#
            #router.include('shared/partials/viewer')#
          </div>
        </div>
        <div class='card-body'>
          <cfif view=='list'>
            <cfloop array='#mUsers#' item='mUser'>
              <div class='row my-3'>
                <div class='col-2'>
                  <a href='#mUser.seo_link()#'>
                    <img class='img-thumbnail w-auto' src='#mUser.profile_image().src()#' />
                  </a>
                </div>
                <div class='col-10'>
                  <div class='fs-5'>
                    <a href='#mUser.seo_link()#'>#mUser.user()#</a>
                    <div>#mUser.UserProfile().firstname()# #mUser.UserProfile().lastname()#</div>
                    <div>#mUser.UserProfile().location()#</div>
                  </div>
                </div>
              </div>
            </cfloop>
          <cfelse>
            <div class='row g-4'>
              <cfloop array='#mUsers#' item='mUser'>
                <div class='col-6 col-md-4 col-lg-3'>
                  <a href='#mUser.seo_link()#'>
                    <img class='img-thumbnail w-100' src='#mUser.profile_image().src()#' />
                  </a>
                  <a href='#mUser.seo_link()#' class='btn btn-sm btn-nmg w-100 mt-1'>
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
    </div>
  </div>
</cfoutput>
