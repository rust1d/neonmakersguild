<cfoutput>
  <div class='modal-header bg-nmg-light'>
    <div class='modal-title'>
      #mBE.title()#
      <cfif isDate(mBE.ben_promoted())>
        <i class='fa-solid fa-fw fa-star text-warning' title='Front Page #mBE.promoted()#'></i>
      </cfif>
    </div>
    <button type='button' class='btn-close' data-bs-dismiss='modal'></button>
  </div>
  <div class='modal-body bg-nmg-light h-100 p-0' data-benid='#mBE.encoded_key()#'>
    <div class='row mx-0 mt-2'>
      <div class='col-auto'>
        <a href='#mBE.User().seo_link()#'>
          <img class='forum-thumbnail rounded' src='#mBE.User().profile_image().src()#' />
        </a>
      </div>
      <div class='col'>
        <div class=''>
          <a href='#mBE.User().seo_link()#'>#mBE.User().user()#</a>
        </div>
        <div class='smaller'>
          <a href='#mBE.seo_link()#'>#mBE.post_date()#</a>
        </div>
      </div>
      <div class='col-12 post-body p-3'>
        #mBE.body_cdn()#
      </div>
    </div>

    <cfif mBE.image_cnt()>
      #new app.services.ImageGrid({ row_class: 'border border-nmg'}).layout(mBE.UserImages())#
    </cfif>

    <div class='row mx-0 mt-2'>
      <div class='col-4'>
      </div>
      <div class='col-4 text-center'>
        <a class='post' href='#mBE.seo_link()###comments'><i class='fa-lg fa-regular fa-comment flip-x'></i> Comment</a>
      </div>
      <div class='col-4 text-end'>
        <a class='post' href='#mBE.seo_link()###comments'>
          #request.utility.updatable_counter(mBE.comment_cnt(), mBE.encoded_key(), request.utility.plural(mBE.comment_cnt(), 'comment'))#
        </a>
      </div>
    </div>

    <hr class='mt-2'>

    <div class='body-comments'>
      <cfif mBE.comment_cnt()>
        <cfloop array='#mBE.BlogComments()#' item='mComment'>
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
  <div class='modal-footer d-block'>
    #router.include('shared/blog/_comment_field', { id: 'benComment' })#
  </div>
</cfoutput>
