<cfoutput>
  <div class='row g-0 mx-0'>
    <div class='d-none d-sm-inline col-sm-auto me-2'>
      <a href='#locals.mComment.User().seo_link()#'>
        <img class='forum-thumbnail rounded' src='#locals.mComment.User().profile_image().src()#' />
      </a>
    </div>
    <div class='col mt-0'>
      <div id='comment-#locals.mComment.encoded_key()#' class='comment-card mb-1'>
        <div class='comment-bubble rounded-4 px-3 py-1'>
          <div class='comment-user'><a href='#locals.mComment.User().seo_link()#'>#locals.mComment.User().user()#</a></div>
          <div class='comment-body'>#locals.mComment.comment()#</div>
        </div>
        <cfif locals.mComment.image_cnt()>
          <cfset locals.mCI = locals.mComment.CommentImages().first() />
          <div class='comment-images rounded-4 position-relative mt-2'>
            <a data-lightbox='comments-#locals.mCI.beiid()#' data-title='#locals.mCI.filename()#' href='#locals.mCI.image_src()#' title='#locals.mCI.filename()#'>
              <img data-pkid=#locals.mCI.encoded_key()# class='comment-thumbnail rounded-4' src='#locals.mCI.image_src()#' />
            </a>
          </div>
        </cfif>
        <div class='comment-viewbar ms-3'>
          <span class='comment-age'>#locals.mComment.age_format()#</span>
          <cfif len(locals.mComment.history())>
            <i class='fa-solid fa-bell text-warning' title='edited'></i>
          </cfif>
          <cfif session.user.loggedIn() && locals.mComment.usid()==session.user.usid()>
            <a class='comment-edit ms-3' data-bcoid='#locals.mComment.bcoid()#' data-key='#locals.mComment.encoded_key()#'>
              <i class='fa-solid fa-pencil'></i>
            </a>
          </cfif>
        </div>
      </div>
    </div>
  </div>
</cfoutput>
