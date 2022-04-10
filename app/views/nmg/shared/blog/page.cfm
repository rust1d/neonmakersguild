<cfoutput>
  <div class='card mt-4 border-0 mb-5'>
    <div class='card-body'>
      <div class='row'>
        <div class='col-12'>
          <div class='row g-2'>
            <div class='col-12 text-center text-uppercase'>
              <small>#locals.mPage.category_links().toList(' &bull; ')#</small>
            </div>
            <div class='col-12 text-center'>
              <h2>
                <a href='#locals.mPage.seo_link()#'>#locals.mPage.title()#</a>
              </h2>
            </div>
            <div class='col-12'>
              #locals.mPage.body()#
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</cfoutput>
