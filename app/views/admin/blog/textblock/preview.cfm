<cfscript>
  mTextBlock = new app.models.BlogTextBlocks(request.unclean);
  flash.info('This is a preview of the `#mTextBlock.label()#` page.', false);
</cfscript>

<cfoutput>
  <section class='container'>
    <div class='row justify-content-center'>
      <div class='col-md-8 border-end'>
        <div class='card mt-4 border-0 mb-5'>
          <div class='card-body border'>
            <div class='row'>
              <div class='col-12'>
                <div class='row g-2'>
                  <div class='col-12 text-center text-uppercase'>
                    <small>Category &bull; Category</small>
                  </div>
                  <div class='col-12'>
                    #mTextBlock.body()#
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>
</cfoutput>