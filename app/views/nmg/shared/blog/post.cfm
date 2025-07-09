<cfoutput>
  <div class='row g-3 justify-content-center'>
    <div class='col-1'>
      <a href='#locals.mBE.User().seo_link()#'>
        <img class='profile-thumbnail img-fluid rounded' src='#locals.mBE.User().profile_image().src()#' />
      </a>
    </div>
    <div class='col-10 text-center'>
      <div class='post-title'>
        <a class='post' data-benid='#locals.mBE.encoded_key()#' href='#locals.mBE.seo_link()#'>
          #locals.mBE.title()#
        </a>
        <cfif isDate(locals.mBE.ben_promoted())>
          <i class='fa-solid fa-fw fa-star text-warning' title='Front Page #locals.mBE.promoted()#'></i>
        </cfif>
      </div>

      <div class='mt-1 post-byline'>
        <a href='#locals.mBE.User().seo_link()#'>#locals.mBE.User().user()#</a>
        &bull;
        <a class='post' data-benid='#locals.mBE.encoded_key()#' href='#locals.mBE.seo_link()#'>#locals.mBE.post_date()#</a>
      </div>
    </div>
    <div class='col-1'>#locals.mbe.beiids().toList()#</div>

    <div class='col-12'>
      <div class='post-body'>
        #locals.mBE.body()#
      </div>
    </div>

    <cfif locals.mBE.image_cnt()>
      <div class='col-8'>
        #new app.services.ImageGrid(locals.mBE.UserImages(), { row_class: 'border border-nmg'}).layout()#
      </div>
    </cfif>
  </div>
  <div class='row g-3 post-comment-bar border-top mt-3'>
    <div class='col-4'>
      <cfif session.user.admin() && locals.mBE.promotable()>
        <button name='btnPromote' data-pkid='#locals.mBE.encoded_key()#' class='btn btn-sm #ifin(locals.mBE.is_promoted(), 'btn-warning', 'btn-nmg')#'>
          #ifin(locals.mBE.is_promoted(), 'Promoted', 'Promote to Front Page')#
        </button>
      </cfif>
    </div>
    <div class='col-4 text-center'>
      <a class='post' data-benid='#locals.mBE.encoded_key()#' href='#locals.mBE.seo_link()###comments'>
        <i class='fa-regular fa-comment flip-x'></i> Comment
      </a>
    </div>
    <div class='col-4 text-end'>
      <div class='comment-counter'>
        <a class='post' data-benid='#locals.mBE.encoded_key()#' href='#locals.mBE.seo_link()###comments'>
          #request.utility.updatable_counter(locals.mBE.comment_cnt(), locals.mBE.encoded_key(), request.utility.plural(locals.mBE.comment_cnt(), 'comment'))#
        </a>
      </div>
    </div>
  </div>
</cfoutput>
