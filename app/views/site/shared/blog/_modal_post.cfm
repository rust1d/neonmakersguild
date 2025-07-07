<cfscript>
  // locals WILL CONTAIN DATA FROM json_content IF XHR; IF CALLED INTERNALLY IT SHOULD PROVIDE AN EMPTY MODAL

  if (locals.keyExists('ben_benid')) {
    mBE = new app.models.BlogEntries().find(locals.ben_benid);
  }
</cfscript>

<cfoutput>
  <cfif locals.keyExists('ben_benid')>
    #router.include('shared/blog/_modal_post_content', { mBE: mBE } )#
  <cfelse>
    <div class='modal fade h-100' id='benModal' tabindex='-1' aria-hidden='true'>
      <div class='modal-dialog modal-dialog-scrollable modal-lg'>
        <div class='modal-content h-100'>
          <div class='modal-header'>
            <h5 class='modal-title'></h5>
            <button type='button' class='btn-close' data-bs-dismiss='modal'></button>
          </div>
          <div class='modal-body'>
            Loading...
          </div>
        </div>
      </div>
    </div>
  </cfif>
</cfoutput>
