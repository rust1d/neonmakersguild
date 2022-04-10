<cfscript>
  mCategory = mBlog.category_find_or_create(router.decode('bcaid'));
  mPages = mBlog.pages(bca_bcaid: router.decode('bcaid'), maxrows: 10);
</cfscript>

<cfoutput>
  <section class='container'>
    <div class='row'>
      <div class='col-md-9 border-end'>
        <div class='text-center bg-light'>
          <h3><a href='#mCategory.seo_link('page')#'>#mCategory.category()#</a></h3>
          <h6>Pages by Category</h6>
        </div>
        <cfloop array='#mPages#' item='mPage' index='idx'>
          #router.include('shared/blog/page', { mPage: mPage, fold: true })#
        </cfloop>
      </div>
      <div class='col-md-3 border-start'>
        #router.include('shared/sidebar')#
      </div>
    </div>
  </section>
</cfoutput>
