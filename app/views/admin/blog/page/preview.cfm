<cfscript>
  mPage = new app.models.BlogPages(request.unclean);
  flash.info('This is a preview of the `#mPage.title()#` page. You can safely close this page.', false);
</cfscript>

<cfoutput>
  <div class='card'>
    <div class='card-body'>
      <div class='row g-3'>
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

    <div class='mt-3 text-center'>
      <button type='button' onclick='window.close()' class='btn btn-nmg'>Close Preview</button>
    </div>

</cfoutput>
