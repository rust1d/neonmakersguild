<cfscript>
  mTextBlock = new app.models.BlogTextBlocks(request.unclean);
  flash.info('This is a preview of the `#mTextBlock.label()#` content block. You can safely close this page.', false);
</cfscript>

<cfoutput>
    <div class='row g-3 justify-content-center'>
      <div class='col-sm-10 col-md-6'>
        <div class='card'>
          <div class='card-body'>
              #mTextBlock.body_cdn()#
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