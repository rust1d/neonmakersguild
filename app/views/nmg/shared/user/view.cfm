<cfoutput>
  <div class='card'>
    <div class='card-header bg-nmg'>
    </div>
    <div class='card-body'>
      <div class='row mb-3'>
        <div class='col-auto'>
          <img class='img-thumbnail' id='profile_image' src='#locals.mUser.profile_image().src()#' />
        </div>
        <div class='col-md-8'>
          <h5>#locals.mUser.UserProfile().name()#</h5>
          <p>#locals.mUser.UserProfile().location()#</p>
        </div>
        <div class='col-auto'>
          <cfloop array='#locals.mUser.social_links()#' item='locals.mLink'>
            <span class='p-3'>#locals.mLink.icon_link()#</span>
          </cfloop>
        </div>
      </div>
      <div class='row'>
        <div class='col-12'>
          <blockquote class='blockquote'>
            #locals.mUser.UserProfile().bio()#
          </blockquote>
        </div>
      </div>
    </div>
  </div>
</cfoutput>
