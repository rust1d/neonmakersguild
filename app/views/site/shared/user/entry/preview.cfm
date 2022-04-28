<cfscript>
  mEntry = new app.models.BlogEntries(form);
  flash.info('This is a preview of the `#mEntry.title()#` post. You can safely close this page.', false);
</cfscript>

<cfoutput>
  <div class='row g-3 justify-content-center'>
    <div class='col-md-10'>
      <div class='card border'>
        <div class='aspect-2-1' style='background-image: url(#mEntry.image()#)'></div>
        <div class='card-body'>
          <div class='row g-2'>
            <div class='col-12 text-center text-uppercase'>
              <small>Category &bull; Category</small>
            </div>
            <div class='col-12 fs-2 text-center'>
              #mEntry.title()#
            </div>
            <div class='col-12 text-center'>
              by #session.user.user()# | #mEntry.posted()#
            </div>
            <div class='col-12'>
              #mEntry.body()#
              #mEntry.morebody()#
            </div>
          </div>
        </div>
      </div>
    </div>
    <div class='col-12'>
      <div class='text-center'>
        <button type='button' onclick='window.close()' class='btn btn-nmg'>Close Preview</button>
      </div>
    </div>
  </div>
</cfoutput>
