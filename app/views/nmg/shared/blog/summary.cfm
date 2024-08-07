<cfoutput>
  <div class='row border border-rounded g-0'>
    <div class='col-4'>
      <div class='aspect-2-1 position-relative overflow-hidden' style='background-image: url(#locals.mEntry.image_url()#);'>
        <cfif !isNull(locals.mEntry.ben_promoted())>
          <span class='ribbon p-1 pb-0'><i class='fa-solid fa-fw fa-star' title='Front Page #locals.mEntry.promoted()#'></i></span>
        </cfif>
      </div>
    </div>
    <div class='col-8'>
      <div class='card border-0 h-100'>
        <div class='card-body pt-1 pb-0'>
          <div class='row g-0'>
            <div class='col-12 text-center text-uppercase fs-6'>
              #locals.mEntry.category_links().toList(' &bull; ')#
            </div>
            <div class='col-12 text-center fs-4'>
              <a href='#locals.mEntry.seo_link()#'>#locals.mEntry.title()#</a>
            </div>
            <div class='col-12 fs-6 d-flex justify-content-center align-items-center'>
              <a href='#locals.mEntry.User().seo_link()#'>#locals.mEntry.User().user()#</a>
              &nbsp;
              <cfif isNull(locals.mEntry.ben_promoted())>&bull;<cfelse><i class='smaller fa-solid fa-fw fa-star text-warning' title='Front Page #locals.mEntry.promoted()#'></i></cfif>
              &nbsp;
                <span class='smaller'>#locals.mEntry.post_date()#</span>
            </div>
            <div class='col-12 fs-6 pt-1'>
              #locals.mEntry.body()#
            </div>
          </div>
        </div>
        <div class='card-footer bg-nmg-light border-0 text-uppercase smaller text-center pt-0 pb-1'>
          <a href='#locals.mEntry.seo_link()#'>Read more</a>
          <cfif locals.mEntry.comments()>
            &bull; <small><a href='#locals.mEntry.seo_link()###comments'>#utility.plural_label(locals.mEntry.comment_cnt(), 'comment')#</a></small>
          </cfif>
        </div>
      </div>
    </div>
  </div>
</cfoutput>
