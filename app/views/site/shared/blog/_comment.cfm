<cfoutput>
  <div class='row g-0 mx-0'>
    <div class='d-none d-sm-inline col-sm-auto ms-3 me-2'>
      <a href='#locals.mComment.User().seo_link()#'>
        <img class='forum-thumbnail rounded' src='#locals.mComment.User().profile_image().src()#' />
      </a>
    </div>
    <div class='col mt-0'>
      <div id='comment-#locals.mComment.encoded_key()#' class='mb-3'>
        <div class='comment rounded-4 bg-comment px-3 py-1'>
          <div class='comment-user smaller fw-semibold'><a href='#locals.mComment.User().seo_link()#'>#locals.mComment.User().user()#</a></div>
          #locals.mComment.comment()#
        </div>
        <cfif locals.mComment.image_cnt()>
          <cfset locals.mCI = locals.mComment.CommentImages().first() />
          <div class='rounded-4 position-relative mt-2'>
            <a data-lightbox='comments-#locals.mCI.beiid()#' data-title='#locals.mCI.filename()#' href='#locals.mCI.image_src()#' title='#locals.mCI.filename()#'>
              <img data-pkid=#locals.mCI.encoded_key()# class='comment-thumbnail rounded-4' src='#locals.mCI.image_src()#' />
            </a>
          </div>
        </cfif>
        <div class='small ms-3'>
          <span class='smaller me-3'>#locals.mComment.age_format()#</span>
          <cfif len(locals.mComment.history())>
            <small class='fst-italic muted me-3' title='#locals.mComment.edited()#'>edited</small>
          </cfif>
          <cfif session.user.loggedIn() && locals.mComment.usid()==session.user.usid()>
            <a class='comment-edit' data-bcoid='#locals.mComment.bcoid()#' data-key='#locals.mComment.encoded_key()#'><i class='fa-solid fa-sm fa-pencil smaller'></i></a>
          </cfif>
        </div>
      </div>
    </div>
  </div>
</cfoutput>
