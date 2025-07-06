<cfoutput>
  <div class='row g-3'>
    <div class='col-1'>
      <a href='#locals.mEntry.User().seo_link()#'>
        <img class='forum-thumbnail rounded' src='#locals.mEntry.User().profile_image().src()#' />
      </a>
    </div>
    <div class='col-10 text-center'>
      <div class='fs-3'>
        <a class='post' data-benid='#locals.mEntry.encoded_key()#' href='#locals.mEntry.seo_link()#'>#locals.mEntry.title()#</a>
      </div>
      <div class='smaller'>
        <a href='#locals.mEntry.User().seo_link()#'>#locals.mEntry.User().user()#</a>
        &bull;
        <a class='post' data-benid='#locals.mEntry.encoded_key()#' href='#locals.mEntry.seo_link()#'>#locals.mEntry.post_date()#</a>
        <cfif isDate(locals.mEntry.ben_promoted())>
          &bull; <i class='fa-solid fa-fw fa-star text-warning' title='Front Page #locals.mEntry.promoted()#'></i>
        </cfif>
      </div>
    </div>
    <div class='col-1'>
    </div>

    <cfif !isNull(locals.mEntry.image())>
      <div class='col-12'>
        <div class='content-card'>
          <div class='blur-frame blur-frame-lg' style='background-image: url(#locals.mEntry.image_url()#)'>
            <img class='' src='#locals.mEntry.image_url()#' />
          </div>
        </div>
      </div>
    </cfif>

    <div class='col-12 post-body'>
      #locals.mEntry.body_cdn()#
    </div>

    <cfif locals.mEntry.image_cnt()>
      <div class='col-12'>
        <div class='w-75 mt-1 mx-auto'>
          #new app.services.ImageGrid({ row_class: 'border border-nmg'}).layout(locals.mEntry.UserImages())#
        </div>
      </div>
    </cfif>

    <div class='col-4 text-center'>
      <cfif session.user.admin() && locals.mEntry.promotable()>
        <button name='btnPromote' data-pkid='#locals.mEntry.encoded_key()#' class='btn btn-sm btn-nmg'>#ifin(isNull(locals.mEntry.ben_promoted()), 'Promote to Front Page', 'Promoted')#</button>
      </cfif>
    </div>
    <div class='col-4 text-center'>
      <a class='post' data-benid='#locals.mEntry.encoded_key()#' href='#locals.mEntry.seo_link()###comments'><i class='fa-lg fa-regular fa-comment flip-x'></i> Comment</a>
    </div>
    <div class='col-4 text-center'>
      <cfif locals.mEntry.comments()>
        <small><a class='post' data-benid='#locals.mEntry.encoded_key()#' href='#locals.mEntry.seo_link()###comments'>#utility.plural_label(locals.mEntry.comment_cnt(), 'comment')#</a></small>
      </cfif>
    </div>
  </div>
</cfoutput>
