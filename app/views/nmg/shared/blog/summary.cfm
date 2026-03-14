<cfoutput>
  <div class='row g-0'>
    <div class='col-12 col-md-5 col-lg-4 col-xxl-3 summary-frame p-0'>
      <cfif locals.mBE.UserImages().len()>
        #new app.services.ImageGrid(locals.mBE.UserImages(), locals.section, { row_class: 'fix-height' }).layout(4)#
      <cfelse>
        <img class='img-fluid rounded' src='#locals.mBE.User().profile_image().src()#' />
      </cfif>
    </div>
    <div class='col-12 col-md-7 col-lg-8 col-xxl-9 p-3 pb-3'>
      <div class='border-0 h-100 d-flex flex-column'>
        <div class='d-flex align-items-start gap-2'>
          <div class='d-none d-sm-block flex-shrink-0'>
            <a href='#locals.mBE.User().seo_link()#'>
              <img class='avatar-circle-sm' src='#locals.mBE.User().profile_image().src()#' />
            </a>
          </div>
          <div class='flex-grow-1 position-relative'>
            <div class='post-title fw-bold me-3'>
              <a class='post post-title-link' data-section='#locals.section#' data-benid='#locals.mBE.encoded_key()#' href='#locals.mBE.seo_link()#'>
                #locals.mBE.title()#
              </a>
              #router.include('shared/blog/_promote', locals)#
            </div>
            <div class='d-flex align-items-center gap-2'>
              <div class='d-inline d-sm-none'>
                <a href='#locals.mBE.User().seo_link()#'>
                  <img class='avatar-circle-sm' src='#locals.mBE.User().profile_image().src()#' />
                </a>
              </div>
              #router.include('shared/blog/_byline', locals)#
            </div>
          </div>
        </div>

        <div class='post-body my-2'>
          #locals.mBE.summary()#
        </div>

        <div class='d-flex mt-auto post-comment-bar border-top pt-2 gap-3 align-items-center font-montserrat small'>
          <div class='comment-counter'>
            <a class='post post-action' data-section='#locals.section#' data-benid='#locals.mBE.encoded_key()#' href='#locals.mBE.seo_link()###comments'>
              <i class='fa-regular fa-comment flip-x me-1'></i>#request.utility.updatable_counter(locals.mBE.comment_cnt(), locals.mBE.encoded_key(), request.utility.plural(locals.mBE.comment_cnt(), 'comment'))#
            </a>
          </div>
          <div class='ms-auto d-flex gap-3'>
            <a class='post post-action' data-section='#locals.section#' data-benid='#locals.mBE.encoded_key()#' href='#locals.mBE.seo_link()###comments'>
              <i class='fa-regular fa-comment flip-x me-1'></i>Reply
            </a>
            <a class='post post-action' data-section='#locals.section#' data-benid='#locals.mBE.encoded_key()#' href='#locals.mBE.seo_link()#'>
              Read more<i class='fa-solid fa-arrow-right ms-1'></i>
            </a>
          </div>
        </div>
      </div>
    </div>
  </div>
</cfoutput>
