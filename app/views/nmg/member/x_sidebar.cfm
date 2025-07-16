<cfoutput>
  <div class='row g-3'>
    <div class='col-12 text-center'>
      <img class='img-thumbnail' src='#mUserBlog.owner().profile_image().src()#' />
    </div>
    <div class='col-12 text-center'>
      <div class='fs-3'>#mUserBlog.owner().user()#</div>
      <div>#mUserBlog.owner().UserProfile().name()#</div>
      <div>#mUserBlog.owner().UserProfile().location()#</div>
    </div>
    <div class='col-12 small'>
      #mUserBlog.owner().UserProfile().bio()#
    </div>
    <div class='col-12'>
      <div class='row justify-content-center'>
        <cfloop array='#mUserBlog.owner().profile_links()#' item='mLink'>
          <div class='col-2'>#mLink.icon_link()#</div>
        </cfloop>
      </div>
    </div>
    <div class='col-12'>
      <div class='row justify-content-center'>
        <cfloop array='#mUserBlog.owner().bookmark_links()#' item='mLink'>
          <div class='col-auto'>#mLink.icon_link()#</div>
          <div class='col smaller'><a class='small' href='#mLink.url()#' data-link='#mLink.datadash()#' target='_blank'>#mLink.title()#</a></div>
        </cfloop>
      </div>
    </div>
  </div>
</cfoutput>
