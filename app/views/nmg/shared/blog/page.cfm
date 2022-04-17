<cfscript>
  param locals.fold = false;
</cfscript>


<cfoutput>
  <div class='row g-3'>
    <div class='col-12 text-center rounded p-3 bg-nmg'>
      <div class='fs-2'><a href='#locals.mPage.seo_link()#'>#locals.mPage.title()#</a></div>
      <small>#locals.mPage.category_links().toList(' &bull; ')#</small>
    </div>
    <div class='col-12 p-3 page border rounded'>
      #locals.mPage.body()#
    </div>
  </div>
</cfoutput>
