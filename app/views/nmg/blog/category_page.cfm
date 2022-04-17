<cfscript>
  mCategory = mBlog.category_find_or_create(router.decode('bcaid'));
  mPages = mBlog.pages(bca_bcaid: router.decode('bcaid'), maxrows: 10);
</cfscript>

<cfoutput>
  <div class='row'>
    <div class='col'>
      <div class='text-center rounded p-3 mb-3 bg-nmg'>
        <h3><a href='#mCategory.seo_link('page')#'>#mCategory.category()#</a></h3>
        <small>Pages by Category</small>
      </div>
      <cfloop array='#mPages#' item='mPage' index='idx'>
        <div class='row p-3 mt-3 page border rounded'>
          <div class='col-12 fs-2 text-center text-page-head mb-3'>
            <a href='#mPage.seo_link()#'>#mPage.title()#</a>
          </div>
          <div class='col-12 text-center text-uppercase'>
            <small>#mPage.category_links().toList(' &bull; ')#</small>
          </div>
        </div>
      </cfloop>
    </div>
  </div>
</cfoutput>
