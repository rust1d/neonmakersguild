<cfscript>
  param locals.fold = false;
</cfscript>


<cfoutput>
  <div class='row'>
    <div class='col-12 text-center rounded-pill p-3 mb-3 bg-nmg-light'>
      <div class='fs-2'><a href='#locals.mPage.seo_link()#'>#locals.mPage.title()#</a></div>
      <small>#locals.mPage.category_links().toList(' &bull; ')#</small>
    </div>
  </div>
  <div>
    #locals.mPage.body()#
  </div>
  <cfif request.router.template_exists('page/#locals.mPage.alias()#')>
    <div class='mt-3'>
      #router.include('page/#locals.mPage.alias()#')#
    </div>
  </cfif>
</cfoutput>
