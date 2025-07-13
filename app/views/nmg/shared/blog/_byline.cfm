<cfscript>
  param locals.comment_target = 'focus';
</cfscript>

<cfoutput>
  <div class='post-byline fw-semibold mt-1'>
    <a href='#locals.mBE.User().seo_link()#'>#locals.mBE.User().user()#</a>
    &bull;
    <a class='post' data-target='#locals.comment_target#' data-section='#locals.section#' data-benid='#locals.mBE.encoded_key()#' href='#locals.mBE.seo_link()#'>#locals.mBE.post_date()#</a>
    <cfif session.user.loggedIn() && locals.mBE.owned_by(session.user.model())>
      &bull;
      <a href='#router.hrefenc(page: 'user/entry/edit', benid: locals.mBE.benid())#' class=''>
        <i class='fa-solid fa-fw fa-pencil'></i>
      </a>
    </cfif>
  </div>
</cfoutput>
