<cfoutput>
  <div class='card border mb-3'>
    <div class='aspect-2-1' style='background-image: url(#locals.mEntry.image()#)'></div>
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
              &bull; <small>#locals.mEntry.post_date()#</small>
            </div>
            <div class='col-12'>
              #locals.mEntry.body()#
              <cfif !locals.fold>#locals.mEntry.morebody()#</cfif>
            </div>
            <div class='col-12 small text-center text-uppercase'>
              <cfif locals.fold && len(locals.mEntry.morebody())>
                <a href='#locals.mEntry.seo_link()#'>Read more</a> &bull;
              </cfif>
              <small><a href='#locals.mEntry.seo_link()###comments'>#utility.plural_label(locals.mEntry.comment_cnt(), 'comment')#</a></small>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</cfoutput>
