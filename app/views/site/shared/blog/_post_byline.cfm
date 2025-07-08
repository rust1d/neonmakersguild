<cfoutput>
  <div class='d-flex align-items-start mx-3 mt-2'>
    <a href='#locals.mBE.User().seo_link()#' class='me-2'>
      <img class='profile-thumbnail rounded' src='#locals.mBE.User().profile_image().src()#' />
    </a>
    <div class='flex-grow-1'>
      <div class=''>
        <a href='#locals.mBE.User().seo_link()#'>#locals.mBE.User().user()#</a>
      </div>
      <div class='post-byline'>
        <a href='#locals.mBE.seo_link()#'>#locals.mBE.post_date()#</a>
      </div>
    </div>
  </div>
</cfoutput>
