<cfscript>
  mBE = mBEI.BlogEntry();
</cfscript>

<cfoutput>
  <div class='modal-body h-100 p-0' data-benid='#mBE.encoded_key()#' data-beiid='#mBEI.encoded_key()#'>
    <div class='row g-0 h-100'>
      <div class='col-9 h-100'>
        <div class='black-frame'>
          <div class='close align-items-center'>
            <button type='button' class='btn-circle' data-bs-dismiss='modal' aria-label='Close'>
              <i class='fas fa-times' aria-hidden='true'></i>
            </button>
            <a href='#application.urls.root#'>
              <img class='ms-3' src='#application.urls.cdn#/assets/images/logo-256.png' />
            </a>
          </div>
          <div class='frame-nav'>
            <button class='btn-circle btn-prev' data-nav='prev' data-beiid='#mBEI.encoded_key()#' aria-label='Previous'>
              <i class='fas fa-chevron-left' aria-hidden='true'></i>
            </button>
            <button class='btn-circle btn-next' data-nav='next' data-beiid='#mBEI.encoded_key()#' aria-label='Next'>
              <i class='fas fa-chevron-right' aria-hidden='true'></i>
            </button>
          </div>
          <img src='#mBEI.UserImage().image_src()#' />
        </div>
      </div>
      <div class='col-3 bg-nmg-light d-flex flex-column h-100 min-h-0'>
        <div class='card scroll-card rounded-0 border-light'>
          <div class='card-header bg-nmg-light'>
            <div class='row g-2'>
              <div class='col-auto'>
                <a href='#mBE.User().seo_link()#'>
                  <img class='forum-thumbnail rounded' src='#mBE.User().profile_image().src()#' />
                </a>
              </div>
              <div class='col-10'>
                <div class=''>
                  <a href='#mBE.User().seo_link()#'>#mBE.User().user()#</a>
                </div>
                <div class='smaller'>
                  <a href='#mBE.seo_link()#'>#mBE.post_date()#</a>
                </div>
              </div>
              <div class='col-12 text-end mt-0'>
                #request.utility.updatable_counter(mBEI.comment_cnt(), mBEI.encoded_key(), '<sup><i class="fa-regular fa-comment"></i></sup>')#
              </div>
            </div>
          </div>
          <div class='card-body'>
            <cfif mBE.image_cnt() GT 1>
              <div class='d-flex justify-content-between align-items-center smaller text-muted'>
                <span><i class='fas fa-images fa-lg me-2'></i> This photo is from a post.</span>
                <a class='fw-semibold' href='#mBE.seo_link()#'>View Post</a>
              </div>
              <hr class='mt-2'>
            </cfif>
            <div class='body-title fs-3 text-center'>
              #mBE.title()#
              <hr>
            </div>
            <div class='body-post'>
              <cfif mBE.image_cnt() GT 1>
                #mBEI.caption()#
              <cfelse>
                #mBE.body_cdn()#
              </cfif>
              <hr>
            </div>
            <div class='body-comments'>
              <cfif mBEI.comment_cnt()>
                <cfloop array='#mBEI.BlogComments()#' item='mComment'>
                  #router.include('shared/blog/_comment', { mComment: mComment })#
                </cfloop>
              <cfelse>
                <div class='text-center mt-5 text-muted empty-comment'>
                  <i class='icon-large fa-regular fa-file'></i>
                  <div class='fs-3 mt-3'>No comments yet</div>
                  <div class='fs-6 mt-3'>Be the first to comment</div>
                </div>
              </cfif>
            </div>
          </div>
          <div class='card-footer bg-white'>
            #router.include('shared/blog/_comment_field', { id: 'beiComment' })#
          </div>
        </div>
      </div>
    </div>
  </div>
</cfoutput>
