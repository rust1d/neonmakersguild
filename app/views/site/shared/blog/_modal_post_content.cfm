<cfoutput>
  <div class='modal-header bg-nmg-light'>
    <div class='d-flex align-items-center flex-grow-1'>
      <a href='#locals.mBE.User().seo_link()#' class='me-2'>
        <img class='avatar-circle' style='width:40px;min-width:40px' src='#locals.mBE.User().profile_image().src()#' />
      </a>
      <div>
        <div class='post-userlink fw-bold'>
          <a href='#locals.mBE.User().seo_link()#'>#locals.mBE.User().user()#</a>
        </div>
        <div class='post-byline small'>
          <a href='#locals.mBE.seo_link()#'>#locals.mBE.post_date()#</a>
          <cfif session.user.loggedIn() && locals.mBE.owned_by(session.user.model())>
            &bull;
            <a href='#router.hrefenc(page: 'user/entry/edit', benid: locals.mBE.benid())#'>
              <i class='fa-solid fa-fw fa-pencil'></i>
            </a>
          </cfif>
        </div>
      </div>
    </div>
    <button type='button' class='btn-close' data-bs-dismiss='modal'></button>
  </div>
  <div class='modal-body bg-nmg-light h-100 p-0 scrollable'>
    <div class='px-3 mt-2'>
      <div class='post-title fs-5'>
        #locals.mBE.title()#
        <cfif isDate(locals.mBE.ben_promoted())>
          <i class='fa-solid fa-fw fa-star text-warning' title='Front Page #locals.mBE.promoted()#'></i>
        </cfif>
      </div>
    </div>

    <div class='post-body px-3 mt-1 mb-1' data-benid='#locals.mBE.encoded_key()#'>
      #locals.mBE.body()#
    </div>

    <cfif locals.mBE.image_cnt()>
      #new app.services.ImageGrid(locals.mBE.UserImages(), locals.section, { row_class: 'border border-nmg'}).layout()#
    </cfif>

    <div class='d-flex justify-content-center gap-4 mt-2 post-comment-bar'>
      <a class='post' href='#locals.mBE.seo_link()###comments'><i class='fa-regular fa-comment flip-x'></i> Comment</a>
      <div class='comment-counter'>
        <a class='post' href='#locals.mBE.seo_link()###comments'>
          #request.utility.updatable_counter(locals.mBE.comment_cnt(), locals.mBE.encoded_key(), request.utility.plural(locals.mBE.comment_cnt(), 'comment'))#
        </a>
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
