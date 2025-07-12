<cfscript>
  locals.mBE = locals.mBEI.BlogEntry();
  locals.mCommentOn = locals.mBE.image_cnt()==1 ? locals.mBE : locals.mBEI;
</cfscript>

<cfoutput>
  <div class='modal-body p-0'>
    <div class='image-modal-layout'>
      <div class='image-modal-image'>
        <div class='position-absolute top-0 start-0 p-3 d-flex align-items-center close'>
          <button type='button' class='btn btn-icon btn-nmg btn-outline-dark fs-4' data-bs-dismiss='modal' aria-label='Close'>
            <i class='fas fa-times'></i>
          </button>
          <a href='#application.urls.root#'>
            <img src='#application.urls.cdn#/assets/images/logo-256.png' height='32' class='ms-3' />
          </a>
        </div>
        <div class='frame-nav position-absolute top-50 start-0 translate-middle-y ps-2'>
          <button class='btn btn-icon btn-prev btn-nmg btn-outline-dark fs-4' data-direction='prev' data-section='#locals.section#' data-beiid='#locals.mBEI.encoded_key()#'>
            <i class='fas fa-chevron-left'></i>
          </button>
        </div>
        <div class='frame-nav position-absolute top-50 end-0 translate-middle-y pe-2'>
          <button class='btn btn-icon btn-next btn-nmg btn-outline-dark fs-4' data-direction='next' data-section='#locals.section#' data-beiid='#locals.mBEI.encoded_key()#'>
            <i class='fas fa-chevron-right'></i>
          </button>
        </div>
        <img class='img-fluid image-modal-img' src='#locals.mBEI.UserImage().image_src()#' alt='Selected Image' />
      </div>
      <aside class='image-modal-sidebar bg-nmg-light d-flex flex-column'>
        <div class='card border-light rounded-0 scroll-card h-100'>
          <div class='card-header bg-nmg-light p-2'>
            #router.include('shared/blog/_modal_byline', { mBE: locals.mBE })#
            <div class='comment-counter text-end px-3 mt-0'>
              #request.utility.updatable_counter(locals.mCommentOn.comment_cnt(), locals.mCommentOn.encoded_key(), '<sup><i class="fa-regular fa-comment"></i></sup>')#
            </div>
          </div>
          <div class='card-body'>
            <cfif locals.mBE.image_cnt() GT 1>
              <div class='d-flex justify-content-between align-items-center smaller text-muted'>
                <span><i class='fas fa-images me-2'></i> This photo is from a post.</span>
                <a class='post fw-semibold' data-benid='#locals.mBE.encoded_key()#' href='#locals.mBE.seo_link()#'>View Post</a>
              </div>
              <hr>
            </cfif>
            <div class='text-center mb-2 post-title fs-5'>#locals.mBE.title()#</div>
            <div class='post-body' data-benid='#locals.mBE.encoded_key()#' data-beiid='#locals.mBEI.encoded_key()#'>
              <cfif locals.mBE.image_cnt() GT 1>
                #locals.mBEI.caption()#
              <cfelse>
                #locals.mBE.body()#
              </cfif>
              <hr>
            </div>
            <div class='post-comments'>
              <cfif locals.mCommentOn.comment_cnt()>
                <cfloop array='#locals.mCommentOn.BlogComments()#' item='mComment'>
                  #router.include('shared/blog/_comment', { mComment: mComment })#
                </cfloop>
              <cfelse>
                #router.include('shared/blog/_no_comments')#
              </cfif>
            </div>
          </div>
          <div class='card-footer bg-white'>
            #router.include('shared/blog/_comment_field', { id: 'beiComment' })#
          </div>
        </div>
      </aside>
    </div>
  </div>
</cfoutput>
