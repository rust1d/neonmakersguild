<cfscript>
  mCategory = mBlog.category_find_or_create(router.decode('bcaid'));
  mPages = mBlog.pages(bca_bcaid: router.decode('bcaid'), maxrows: 10);
</cfscript>

<cfoutput>
  <div class='row g-3'>
    <div class='col-12 text-center rounded-pill p-3 bg-nmg-light'>
      <div class='fs-2'><a href='#mCategory.seo_link('page')#'>#mCategory.category()#</a></div>
      <small>Pages by Category</small>
    </div>
    <cfloop array='#mPages#' item='mPage' index='idx'>
      <div class='col-12'>
        <div class='row rounded-pill p-3 bg-nmg-light'>
          <div class='col-12 fs-2 text-center text-page-head mb-3'>
            <a href='#mPage.seo_link()#'>#mPage.title()#</a>
          </div>
          <div class='col-12 text-center text-uppercase'>
            <small>#mPage.category_links().toList(' &bull; ')#</small>
          </div>
        </div>
      </div>
    </cfloop>
  </div>
</cfoutput>
