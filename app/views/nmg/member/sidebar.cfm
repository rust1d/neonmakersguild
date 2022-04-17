<cfoutput>
  <div class='row g-3'>
    <div class='col-12 text-center'>
      <img class='img-thumbnail' src='#mBlog.owner().profile_image().src()#' />
    </div>
    <div class='col-12 text-center'>
      <div class='fs-3'>#mBlog.owner().user()#</div>
      <div>#mBlog.owner().UserProfile().name()#</div>
      <div>#mBlog.owner().UserProfile().location()#</div>
    </div>
    <div class='col-12 small'>
      #mBlog.owner().UserProfile().bio()#
    </div>
    <div class='col-12'>
      <div class='row justify-content-center'>
        <cfloop array='#mBlog.owner().social_links()#' item='mLink'>
          <div class='col-2'>#mLink.icon_link()#</div>
        </cfloop>
      </div>
    </div>
  </div>
</cfoutput>
