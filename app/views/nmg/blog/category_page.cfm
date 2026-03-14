<cfscript>
  mCategory = mBlog.category_find_or_create(router.decode('bcaid'));
  mPages = mBlog.pages(bca_bcaid: router.decode('bcaid'), maxrows: 10);
</cfscript>

<cfoutput>
  <div class='row g-3'>
    <div class='col-12 content-card bg-nmg-dark text-center p-3'>
      <div class='fs-2 text-marker text-white'>#mCategory.category()#</div>
      <small class='text-white-50'>Pages by Category</small>
    </div>
    <cfloop array='#mPages#' item='mPage' index='idx'>
      <div class='col-12'>
        <a href='#mPage.seo_link()#' class='text-decoration-none'>
          <div class='content-card hover-lift p-3 text-center'>
            <div class='fs-4 text-marker mb-2'>#mPage.title()#</div>
            <div class='text-uppercase text-secondary'>
              <small>#mPage.category_links().toList(' &bull; ')#</small>
            </div>
          </div>
        </a>
      </div>
    </cfloop>
  </div>
</cfoutput>
