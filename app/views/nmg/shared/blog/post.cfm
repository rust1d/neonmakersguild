<cfscript>
  param locals.comment_target = 'focus';
</cfscript>

<cfoutput>
  <div class='row g-3 justify-content-center'>
    <div class='col-auto'>
      <a href='#locals.mBE.User().seo_link()#'>
        <img class='profile-thumbnail img-fluid rounded' src='#locals.mBE.User().profile_image().src()#' />
      </a>
    </div>
    <div class='col position-relative'>
      <div class='post-title fs-5'>
        <a class='post' data-target='#locals.comment_target#' data-section='#locals.section#' data-benid='#locals.mBE.encoded_key()#' href='#locals.mBE.seo_link()#'>
          #locals.mBE.title()#
        </a>
        #router.include('shared/blog/_promote', locals)#
      </div>
      #router.include('shared/blog/_byline', locals)#
    </div>

    <div class='col-12'>
      <div class='post-body' data-benid='#locals.mBE.encoded_key()#'>
        #locals.mBE.body()#
      </div>
    </div>

    <cfif locals.mBE.image_cnt()>
      <div class='col-md-8 col-lg-10 p-0'>
        #new app.services.ImageGrid(locals.mBE.UserImages(), locals.section, { row_class: 'border border-nmg'}).layout()#
      </div>
    </cfif>
  </div>
  <div class='row g-3 post-comment-bar border-top mt-3'>
    <div class='col-4'>

    </div>
    <div class='col-4 text-center'>
      <a class='post' data-target='#locals.comment_target#' data-section='#locals.section#' data-benid='#locals.mBE.encoded_key()#' href='#locals.mBE.seo_link()###comments'>
        <i class='fa-regular fa-comment flip-x'></i> Comment
      </a>
    </div>
    <div class='col-4 text-end'>
      <div class='comment-counter'>
        <a class='post' data-target='#locals.comment_target#' data-section='#locals.section#' data-benid='#locals.mBE.encoded_key()#' href='#locals.mBE.seo_link()###comments'>
          #request.utility.updatable_counter(locals.mBE.comment_cnt(), locals.mBE.encoded_key(), request.utility.plural(locals.mBE.comment_cnt(), 'comment'))#
        </a>
      </div>
    </div>
  </div>
</cfoutput>
