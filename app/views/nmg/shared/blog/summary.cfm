<cfoutput>
  <div class='row g-0'>
    <div class='col-12 col-md-6 col-lg-5 col-xl-4 summary-frame p-0'>
      #new app.services.ImageGrid(locals.mBE.UserImages(), locals.section, { row_class: 'fix-height' }).layout(3)#
    </div>
    <div class='col-12 col-md-6 col-lg-7 col-xl-8 p-3 pb-3'>
      <div class='border-0 h-100 d-flex flex-column'>
        <div class='row g-2'>
          <div class='col-1'>
            <a href='#locals.mBE.User().seo_link()#'>
              <img class='profile-thumbnail img-fluid rounded' src='#locals.mBE.User().profile_image().src()#' />
            </a>
          </div>
          <div class='col-10 text-center'>
            <div class='post-title fs-5 mx-2'>
              <a class='post' data-section='#locals.section#' data-benid='#locals.mBE.encoded_key()#' href='#locals.mBE.seo_link()#'>
                #locals.mBE.title()#
              </a>
              <cfif isDate(locals.mBE.ben_promoted())>
                <i class='fa-solid fa-fw fa-star text-warning' title='Front Page #locals.mBE.promoted()#'></i>
              </cfif>
            </div>
            <div class='mt-1 post-byline'>
              <a href='#locals.mBE.User().seo_link()#'>#locals.mBE.User().user()#</a>
              &bull;
              <a class='post' data-section='#locals.section#' data-benid='#locals.mBE.encoded_key()#' href='#locals.mBE.seo_link()#'>#locals.mBE.post_date()#</a>
            </div>
          </div>
          <div class='col-1'></div>
        </div>
        <div class='post-body mt-2'>
          #locals.mBE.summary()#
        </div>

        <div class='row mt-auto post-comment-bar border-top pt-2'>
          <div class='col-4'>
            <a class='post' data-section='#locals.section#' data-benid='#locals.mBE.encoded_key()#' href='#locals.mBE.seo_link()#'>Read more</a>
          </div>
          <div class='col-4 text-center'>
            <a class='post' data-section='#locals.section#' data-benid='#locals.mBE.encoded_key()#' href='#locals.mBE.seo_link()###comments'>
              <i class='fa-regular fa-comment flip-x'></i> Comment
            </a>
          </div>
          <div class='col-4 text-end'>
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
