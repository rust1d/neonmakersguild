<cfscript>
  // locals WILL CONTAIN DATA FROM json_content IF XHR; IF CALLED INTERNALLY IT SHOULD PROVIDE AN EMPTY MODAL
  if (locals.keyExists('bei_beiid')) {
    locals.mBEI = new app.models.BlogEntryImages().find_nav(argumentcollection: locals);
  }
</cfscript>

<cfoutput>
  <cfif locals.keyExists('bei_beiid')>
    <!--- #writeoutput(serializejson(locals))# --->
    #router.include('shared/blog/_modal_image_content', { mBEI: locals.mBEI, section: locals.section })#
  <cfelse>
    <div class='modal fade h-100' id='beiModal' tabindex='-1' aria-hidden='true'>
      <div class='modal-dialog modal-fullscreen'>
        <div class='modal-content h-100'>
          <div class='modal-header'>
            <h5 class='modal-title'></h5>
            <button type='button' class='btn-close' data-bs-dismiss='modal' aria-label='Close'></button>
          </div>
          <div class='modal-body'>
            Loading...
          </div>
        </div>
      </div>
    </div>
  </cfif>
</cfoutput>
