<cfscript>
  mTextBlock = new app.models.BlogTextBlocks(request.unclean);
  flash.info('This is a preview of the `#mTextBlock.label()#` textblock.', false);
</cfscript>

<cfoutput>
  <section class='container'>
    <div class='row justify-content-center'>
      <div class='col-md-8'>
        <div class='card mt-3'>
          <div class='card-body'>
              #mTextBlock.body()#
          </div>
        </div>
      </div>
    </div>
  </section>
</cfoutput>