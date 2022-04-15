<cfscript>
  param locals.fold = false;
</cfscript>

<cfoutput>
  <div class='row'>
    <div class='col-12 fs-2 text-center text-page-head mb-3'>
      <a href='#locals.mPage.seo_link()#'>#locals.mPage.title()#</a>
    </div>
    <cfif !locals.fold>
      <div class='col-12'>
        #locals.mPage.body()#
      </div>
    </cfif>
    <div class='col-12 text-center text-uppercase'>
      <small>#locals.mPage.category_links().toList(' &bull; ')#</small>
    </div>
  </div>
</cfoutput>
