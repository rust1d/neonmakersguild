<cfoutput>
  <div class='row g-3'>
    <div class='col-12 text-center'>
      <div class='fs-3'>#mUser.user()#</div>
      <div>#mUser.UserProfile().name()#</div>
      <div>#mUser.UserProfile().location()#</div>
    </div>
    <div class='col-12 text-center'>
      <img class='img-thumbnail' src='#mUser.profile_image().src()#' />
    </div>
    <div class='col-12 small'>
      #mUser.UserProfile().bio()#
    </div>
    <div class='col-12'>
      <div class='row justify-content-center'>
        <cfloop array='#mUser.social_links()#' item='mLink'>
          <div class='col-2'>#mLink.icon_link()#</div>
        </cfloop>
      </div>
    </div>
  </div>
</cfoutput>
