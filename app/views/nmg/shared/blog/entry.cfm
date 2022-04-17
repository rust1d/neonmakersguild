<cfoutput>
  <div class='card border mb-3'>
    <div class='card-body'>
      <div class='row'>
        <div class='col-12 px-4'>
          <div class='row g-2'>
            <div class='col-12 text-center text-uppercase'>
              <small>#locals.mEntry.category_links().toList(' &bull; ')#</small>
            </div>
            <div class='col-12 text-center'>
              <h3><a href='#locals.mEntry.seo_link()#'>#locals.mEntry.title()#</a></h3>
            </div>
            <div class='col-12 text-center'>
              <a href='#locals.mEntry.User().seo_link()#'>#locals.mEntry.User().user()#</a> &bull; <small>#locals.mEntry.post_date()#</small>
            </div>
            <div class='col-12'>
              #locals.mEntry.body()#
              <cfif !locals.fold>#locals.mEntry.morebody()#</cfif>
            </div>
            <cfif locals.fold && len(locals.mEntry.morebody())>
              <div class='col-12 text-center text-uppercase'>
                <a href='#locals.mEntry.seo_link()#'>Read more</a>
              </div>
            </cfif>
          </div>
        </div>
      </div>
    </div>
  </div>
</cfoutput>
