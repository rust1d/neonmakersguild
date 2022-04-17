<cfscript>
  mEntry = new app.models.BlogEntries(form);
  flash.info('This is a preview of the `#mEntry.title()#` post.', false);

</cfscript>

<cfoutput>
    <div class='row justify-content-center'>
      <div class='col-md-10'>
        <div class='card'>
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
    </div>
</cfoutput>
