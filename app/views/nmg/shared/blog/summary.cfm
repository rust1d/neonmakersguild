<cfoutput>
  <div class='row g-0'>
    <div class='col-12 col-md-5 col-lg-4 col-xxl-3 summary-frame p-0'>
      #new app.services.ImageGrid(locals.mBE.UserImages(), locals.section, { row_class: 'fix-height' }).layout(3)#
    </div>
    <div class='col-12 col-md-7 col-lg-8 col-xxl-9 p-3 pb-3'>
      <div class='border-0 h-100 d-flex flex-column'>
        <div class='row g-2'>
          <div class='col-auto'>
            <a href='#locals.mBE.User().seo_link()#'>
              <img class='profile-thumbnail img-fluid rounded' src='#locals.mBE.User().profile_image().src()#' />
            </a>
          </div>
          <div class='col position-relative'>
            <div class='post-title fs-5'>
              <a class='post' data-section='#locals.section#' data-benid='#locals.mBE.encoded_key()#' href='#locals.mBE.seo_link()#'>
                #locals.mBE.title()#
              </a>
              #router.include('shared/blog/_promote', locals)#
            </div>
            #router.include('shared/blog/_byline', locals)#
          </div>
        </div>
        <div class='post-body my-2'>
          #locals.mBE.summary()#
        </div>

        <div class='row mt-auto post-comment-bar border-top pt-2'>
          <div class='d-none d-sm-block col-sm-4 text-end'>
            <a class='post' data-section='#locals.section#' data-benid='#locals.mBE.encoded_key()#' href='#locals.mBE.seo_link()#'>Read more</a>
          </div>
          <div class='col-6 col-sm-4 text-center'>
            <a class='post' data-section='#locals.section#' data-benid='#locals.mBE.encoded_key()#' href='#locals.mBE.seo_link()###comments'>
              <i class='fa-regular fa-comment flip-x'></i> Comment
            </a>
          </div>
          <div class='col-6 col-sm-4 text-center text-sm-start '>
            <div class='comment-counter'>
              <a class='post' data-section='#locals.section#' data-benid='#locals.mBE.encoded_key()#' href='#locals.mBE.seo_link()###comments'>
                #request.utility.updatable_counter(locals.mBE.comment_cnt(), locals.mBE.encoded_key(), request.utility.plural(locals.mBE.comment_cnt(), 'comment'))#
              </a>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</cfoutput>
