<cfoutput>
  <div class='card mt-4 border-0 mb-5'>
    <div class='card-body border'>
      <div class='row'>
        <div class='col-12'>
          <div class='row g-2'>
            <div class='col-12 text-center text-uppercase'>
              <small>#locals.mEntry.category_links().toList(' &bull; ')#</small>
            </div>
            <div class='col-12 text-center'>
              <h3><a href='#locals.mEntry.seo_link()#'>#locals.mEntry.title()#</a></h3>
            </div>
            <div class='col-12 text-center'>
              by <a href='#locals.mEntry.User().seo_link()#'>#locals.mEntry.User().user()#</a> | #locals.mEntry.posted()#
            </div>
            <div class='col-12'>
              #locals.mEntry.body()#
              <cfif !locals.fold>#locals.mEntry.morebody()#</cfif>
            </div>
            <cfif locals.fold && len(locals.mEntry.morebody())>
              <div class='col-12 text-center text-uppercase'>
                <a href='#router.hrefenc(page: 'blog/entry', benid: locals.mEntry.benid())#'>Read more</a>
              </div>
            </cfif>
          </div>
        </div>
      </div>
    </div>
  </div>
</cfoutput>
