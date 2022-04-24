<cfscript>
  mTextBlock = new app.models.BlogTextBlocks(request.unclean);
  flash.info('This is a preview of the `#mTextBlock.label()#` content block. You can safely close this page.', false);
</cfscript>

<cfoutput>
    <div class='row justify-content-center'>
      <div class='col-sm-10 col-md-6'>
        <div class='card'>
          <div class='card-body'>
              #mTextBlock.body()#
          </div>
        </div>
      </div>
    </div>
</cfoutput>