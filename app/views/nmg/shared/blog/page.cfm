<cfscript>
  param locals.fold = false;
</cfscript>

<cfoutput>
  <div class='row g-3'>
    <div class='col-12 text-center content-card bg-nmg-dark text-white py-4'>
      <div class='fs-2 text-marker'><a href='#locals.mPage.seo_link()#' class='text-white text-decoration-none'>#locals.mPage.title()#</a></div>
      <div class='small text-white-50'>#locals.mPage.category_links().toList(' &bull; ')#</div>
    </div>
    <div class='col-12 content-card'>
      #locals.mPage.body_cdn()#
    </div>
    <cfif request.router.template_exists('page/#locals.mPage.alias()#')>
      <div class='col-12'>
        #router.include('page/#locals.mPage.alias()#', { mPage: locals.mPage })#
      </div>
    </cfif>
  </div>
</cfoutput>
