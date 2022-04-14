<cfscript>
  param locals.fold = false;
</cfscript>

<cfoutput>
  <div class='card mt-4 border-0 mb-5'>
    <div class='card-body'>
      <div class='row g-2'>
        <cfif !locals.fold>
        </cfif>
        <div class='col-12 text-center'>
          <h3><a href='#locals.mPage.seo_link()#'>#locals.mPage.title()#</a></h3>
        </div>
        <hr>
        <cfif !locals.fold>
          <div class='col-12'>
            #locals.mPage.body()#
          </div>
        </cfif>
        <hr>
        <div class='col-12 text-center text-uppercase'>
          <small>#locals.mPage.category_links().toList(' &bull; ')#</small>
        </div>
      </div>
    </div>
  </div>
</cfoutput>
