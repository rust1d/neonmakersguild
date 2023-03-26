<cfscript>
  param locals.promote = false;
</cfscript>

<cfoutput>
  <div class='card border'>
    <div class='aspect-2-1 position-relative' style='background-image: url(#locals.mEntry.image_url()#)'>
      <cfif locals.promote && locals.mEntry.promotable()>
        <button name='btnPromote' data-pkid='#locals.mEntry.encoded_key()#' class='btn btn-sm btn-nmg m-1 btn-floating bottom-0 end-0'>#ifin(isNull(locals.mEntry.ben_promoted()), 'Promote to Front Page', 'Promoted')#</button>
      </cfif>
    </div>
    <div class='card-body'>
      <div class='row'>
        <div class='col-12 px-4'>
          <div class='row g-2'>
            <div class='col-12 text-center text-uppercase'>
              <small>#locals.mEntry.category_links().toList(' &bull; ')#</small>
            </div>
            <div class='col-12 text-center fs-3'>
              <a href='#locals.mEntry.seo_link()#'>#locals.mEntry.title()#</a>
            </div>
            <div class='col-12 text-center'>
              <a href='#locals.mEntry.User().seo_link()#'>#locals.mEntry.User().user()#</a>
              <cfif isNull(locals.mEntry.ben_promoted())>&bull; <cfelse><i class='smaller fa-solid fa-star text-warning' title='Front Page #locals.mEntry.promoted()#'></i></cfif>
              <small>#locals.mEntry.post_date()#</small>
            </div>
            <div class='col-12'>
              <cfif locals.fold>
                #locals.mEntry.body()#
              <cfelse>
                #locals.mEntry.body_cdn()#
              </cfif>
            </div>
            <div class='col-12 small text-center text-uppercase'>
              <cfif locals.fold && len(locals.mEntry.body_cdn())>
                <a href='#locals.mEntry.seo_link()#'>Read more</a>
                <cfif locals.mEntry.comments()>&bull;</cfif>
              </cfif>
              <cfif locals.mEntry.comments()>
                <small><a href='#locals.mEntry.seo_link()###comments'>#utility.plural_label(locals.mEntry.comment_cnt(), 'comment')#</a></small>
              </cfif>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</cfoutput>
