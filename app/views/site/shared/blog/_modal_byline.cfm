<cfoutput>
  <div class='d-flex align-items-start mx-3 mt-2'>
    <a href='#locals.mBE.User().seo_link()#' class='me-2'>
      <img class='profile-thumbnail rounded' src='#locals.mBE.User().profile_image().src()#' />
    </a>
    <div class='flex-grow-1'>
      <div class='post-userlink'>
        <a href='#locals.mBE.User().seo_link()#'>#locals.mBE.User().user()#</a>
      </div>
      <div class='post-byline'>
        <a href='#locals.mBE.seo_link()#'>#locals.mBE.post_date()#</a>
        <cfif session.user.loggedIn() && locals.mBE.owned_by(session.user.model())>
          &bull;
          <a href='#router.hrefenc(page: 'user/entry/edit', benid: locals.mBE.benid())#' class=''>
            <i class='fa-solid fa-fw fa-pencil'></i>
          </a>
        </cfif>
      </div>
    </div>
  </div>
</cfoutput>
