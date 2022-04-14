<cfscript>
  mCategory = mBlog.category_find_or_create(router.decode('bcaid'));
  mEntries = mBlog.entries(bca_bcaid: router.decode('bcaid'), maxrows: 10);
</cfscript>

<cfoutput>
  <section class='container'>
    <div class='row'>
      <div class='col-md-9 border-end'>
        <div class='text-center bg-light'>
          <h3><a href='#mCategory.seo_link('post')#'>#mCategory.category()#</a></h3>
          <h6>Posts by Category</h6>
        </div>
        <cfloop array='#mEntries#' item='mEntry' index='idx'>
          #router.include('shared/blog/entry', { mEntry: mEntry, fold: true })#
        </cfloop>
      </div>
      <div class='col-md-3 border-start'>
        #router.include('shared/sidebar')#
      </div>
    </div>
  </section>
</cfoutput>