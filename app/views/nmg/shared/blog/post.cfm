<cfscript>
  param locals.comment_target = 'focus';
</cfscript>

<cfoutput>
  <div class='row g-3 justify-content-center'>
    <div class='d-none d-sm-block col-sm-auto'>
      <a href='#locals.mBE.User().seo_link()#'>
        <img class='avatar-circle' style='width:48px;min-width:48px' src='#locals.mBE.User().profile_image().src()#' />
      </a>
    </div>
    <div class='col position-relative'>
      <div class='post-title fw-semibold'>
        <a class='post' data-target='#locals.comment_target#' data-section='#locals.section#' data-benid='#locals.mBE.encoded_key()#' href='#locals.mBE.seo_link()#'>
          #locals.mBE.title()#
        </a>
        <cfif !locals.mBE.released() && session.user.isUser(locals.mBE.usid())>
          <span class='badge bg-info ms-1'>Draft</span>
        </cfif>
        #router.include('shared/blog/_promote', locals)#
      </div>
      <div class='d-flex align-items-center gap-2'>
        <div class='d-xs-inline d-sm-none'>
          <a href='#locals.mBE.User().seo_link()#'>
            <img class='avatar-circle' style='width:32px;min-width:32px' src='#locals.mBE.User().profile_image().src()#' />
          </a>
        </div>
        #router.include('shared/blog/_byline', locals)#
      </div>
    </div>

    <div class='col-12'>
      <div class='post-body' data-benid='#locals.mBE.encoded_key()#'>
        #locals.mBE.body()#
      </div>
    </div>

    <cfif locals.mBE.image_cnt()>
      <div class='col-md-8 col-lg-10 p-0'>
        #new app.services.ImageGrid(locals.mBE.UserImages(), locals.section, { row_class: 'border border-nmg'}).layout()#
      </div>
    </cfif>
  </div>
  <div class='d-flex justify-content-center gap-4 post-comment-bar border-top mt-3 pt-2'>
    <a class='post' data-target='#locals.comment_target#' data-section='#locals.section#' data-benid='#locals.mBE.encoded_key()#' href='#locals.mBE.seo_link()###comments'>
      <i class='fa-regular fa-comment flip-x me-1'></i> Comment
    </a>
    <div class='comment-counter'>
      <a class='post' data-target='#locals.comment_target#' data-section='#locals.section#' data-benid='#locals.mBE.encoded_key()#' href='#locals.mBE.seo_link()###comments'>
        #request.utility.updatable_counter(locals.mBE.comment_cnt(), locals.mBE.encoded_key(), request.utility.plural(locals.mBE.comment_cnt(), 'comment'))#
      </a>
    </div>
  </div>
</cfoutput>
