<cfoutput>
  <div class='modal-header bg-nmg-light justify-content-center position-relative'>
    <div class='modal-title post-title fs-5'>
      #locals.mBE.title()#
      <cfif isDate(locals.mBE.ben_promoted())>
        <i class='fa-solid fa-fw fa-star text-warning' title='Front Page #locals.mBE.promoted()#'></i>
      </cfif>
    </div>
    <button type='button' class='btn-close position-absolute end-0 translate-middle-y me-3 mt-4' data-bs-dismiss='modal'></button>
  </div>
  <div class='modal-body bg-nmg-light h-100 p-0 scrollable'>
    #router.include('shared/blog/_modal_byline', { mBE: locals.mBE })#

    <div class='post-body px-3 mt-2' data-benid='#locals.mBE.encoded_key()#'>
      #locals.mBE.body()#
    </div>

    <cfif locals.mBE.image_cnt()>
      #new app.services.ImageGrid(locals.mBE.UserImages(), locals.section, { row_class: 'border border-nmg'}).layout()#
    </cfif>

    <div class='row mx-0 mt-2 post-comment-bar'>
      <div class='col-4'>
      </div>
      <div class='col-4 text-center'>
        <a class='post' href='#locals.mBE.seo_link()###comments'><i class='fa-regular fa-comment flip-x'></i> Comment</a>
      </div>
      <div class='col-4 text-end'>
        <div class='comment-counter'>
          <a class='post' href='#locals.mBE.seo_link()###comments'>
            #request.utility.updatable_counter(locals.mBE.comment_cnt(), locals.mBE.encoded_key(), request.utility.plural(locals.mBE.comment_cnt(), 'comment'))#
          </a>
        </div>
      </div>
    </div>

    <hr class='mt-2'>

    <div class='post-comments mx-2'>
      <cfif locals.mBE.comment_cnt()>
        <cfloop array='#locals.mBE.BlogComments()#' item='mComment'>
          #router.include('shared/blog/_comment', { mComment: mComment })#
        </cfloop>
      <cfelse>
        #router.include('shared/blog/_no_comments')#
      </cfif>
    </div>
  </div>
  <div class='modal-footer d-block bg-nmg-light'>
    #router.include('shared/blog/_comment_field', { id: 'benComment' })#
  </div>
</cfoutput>
