<cfscript>
  param locals.aspect = true;
</cfscript>

<cfoutput>
  <div class='modal fade' id='cropModal' tabindex='-1' aria-labelledby='cropModalLabel' aria-hidden='true'>
    <div class='modal-dialog modal-fullscreen'>
      <div class='modal-content d-flex flex-column'>
        <div class='modal-header'>
          <h5 class='modal-title' id='cropModalLabel'>Crop Image</h5>
          <button type='button' class='btn-close' data-bs-dismiss='modal' aria-label='Close'></button>
        </div>
        <div class='modal-body p-3'>
          <div class='d-flex justify-content-center'>
            <div id='thumbnail_crop' class='w-100' style='max-width: 90vw; max-height: 80vh;'></div>
          </div>
        </div>
        <div class='modal-footer flex-wrap justify-content-between align-items-center gap-2'>
          <div class='d-flex gap-2'>
            <div class='btn-group' role='group'>
              <button type='button' class='btn btn-outline-nmg' id='btnRotateLeft' title='Rotate Left'>
                <i class='fa-solid fa-rotate-left me-1'></i>
              </button>
              <button type='button' class='btn btn-outline-nmg' id='btnRotateRight' title='Rotate Right'>
                <i class='fa-solid fa-rotate-right me-1'></i>
              </button>
            </div>
            <cfif locals.aspect>
              <div class='btn-group' role='group' id='btnAspectGroup'>
                <button type='button' class='btn btn-outline-nmg active' id='btnAspectFree'>Free</button>
                <button type='button' class='btn btn-outline-nmg' id='btnAspectSquare'>1:1</button>
                <button type='button' class='btn btn-outline-nmg' id='btnAspect43'>4:3</button>
              </div>
            </cfif>
          </div>
          <div class='d-flex flex-column align-items-center w-50'>
            <input type='range' class='form-range' id='zoomSlider' min='0' max='1' step='0.01' value='0' />
          </div>
          <div class='d-flex gap-2'>
            <button type='button' class='btn btn-wide btn-nmg' id='btnCrop'>Save</button>
            <button type='button' class='btn btn-wide btn-nmg-cancel' data-bs-dismiss='modal'>Cancel</button>
          </div>
        </div>
      </div>
    </div>
  </div>
</cfoutput>
