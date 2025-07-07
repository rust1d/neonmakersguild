<cfoutput>
  <div class='modal-header bg-nmg-light justify-content-center position-relative'>
    <div class='modal-title post-title'>
      #locals.mBE.title()#
      <cfif isDate(locals.mBE.ben_promoted())>
        <i class='fa-solid fa-fw fa-star text-warning' title='Front Page #locals.mBE.promoted()#'></i>
      </cfif>
    </div>
    <button type='button' class='btn-close position-absolute end-0 translate-middle-y me-3 mt-4' data-bs-dismiss='modal'></button>
  </div>
  <div class='modal-body bg-nmg-light h-100 p-0 scrollable' data-benid='#locals.mBE.encoded_key()#'>
    <div class='row mx-0 mt-2'>
      <div class='col-auto'>
        <a href='#locals.mBE.User().seo_link()#'>
          <img class='forum-thumbnail rounded' src='#locals.mBE.User().profile_image().src()#' />
        </a>
      </div>
      <div class='col'>
        <div class=''>
          <a href='#locals.mBE.User().seo_link()#'>#locals.mBE.User().user()#</a>
        </div>
        <div class='smaller'>
          <a href='#locals.mBE.seo_link()#'>#locals.mBE.post_date()#</a>
        </div>
      </div>
      <div class='col-12 post-body p-3'>
        #locals.mBE.body()#
      </div>
    </div>

    <cfif locals.mBE.image_cnt()>
      #new app.services.ImageGrid({ row_class: 'border border-nmg'}).layout(locals.mBE.UserImages())#
    </cfif>

    <div class='row mx-0 mt-2 post-comment-bar'>
      <div class='col-4'>
      </div>
      <div class='col-4 text-center'>
        <a class='post' href='#locals.mBE.seo_link()###comments'><i class='fa-regular fa-comment flip-x'></i> Comment</a>
      </div>
      <div class='col-4 text-end'>
        <a class='post' href='#locals.mBE.seo_link()###comments'>
          #request.utility.updatable_counter(locals.mBE.comment_cnt(), locals.mBE.encoded_key(), request.utility.plural(locals.mBE.comment_cnt(), 'comment'))#
        </a>
      </div>
    </div>

    <hr class='mt-2'>

    <div class='post-comments'>
      <cfif locals.mBE.comment_cnt()>
        <cfloop array='#locals.mBE.BlogComments()#' item='mComment'>
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
  <div class='modal-footer d-block bg-nmg-light'>
    #router.include('shared/blog/_comment_field', { id: 'benComment' })#
  </div>
</cfoutput>
