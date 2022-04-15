<cfscript>
  mPage = new app.models.BlogPages(request.unclean);
  flash.info('This is a preview of the `#mPage.title()#` page.', false);
</cfscript>

<cfoutput>
  <div class='card'>
    <div class='card-body'>
      <div class='row g-2'>
        <div class='col-12 fs-2 text-center'>
          #mPage.title()#
        </div>
        <div class='col-12'>
          #mPage.body()#
        </div>
        <div class='col-12 text-center text-uppercase'>
          <small>Category &bull; Category</small>
        </div>
      </div>
    </div>
  </div>
</cfoutput>
