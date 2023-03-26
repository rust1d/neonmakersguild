<cfscript>
  param locals.fold = false;
</cfscript>

<cfoutput>
  <div class='row g-3'>
    <div class='col-12 text-center rounded-pill p-3 bg-nmg-light'>
      <div class='fs-2'><a href='#locals.mPage.seo_link()#'>#locals.mPage.title()#</a></div>
      <small>#locals.mPage.category_links().toList(' &bull; ')#</small>
    </div>
    <div class='col-12'>
      #locals.mPage.body_cdn()#
    </div>
    <cfif request.router.template_exists('page/#locals.mPage.alias()#')>
      <div class='col-12'>
        #router.include('page/#locals.mPage.alias()#', { mPage: locals.mPage })#
      </div>
    </cfif>
  </div>
</cfoutput>
