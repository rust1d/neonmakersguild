<script src='/assets/js/user/profile_image.js'></script>

<cfoutput>
  <cfif mUser.profile_image().exists()>
    <div class='row mb-3'>
      <div class='col-auto'>
        <div class='position-relative'>
          <img class='img-thumbnail' id='profile_image' src='#mUser.profile_image().src()#' />
          <button type='button' data-bs-target='##profile_modal' data-bs-toggle='modal' class='profile-upload-btn btn btn-sm btn-nmg btn-floating fal fa-camera'></button>
        </div>
      </div>
    </div>
  <cfelse>
    <div class='row mb-3'>
      <div class='col-12'>
        <button type='button' data-bs-target='##profile_modal' data-bs-toggle='modal' class='position-relative profile-upload-btn btn btn-sm btn-nmg btn-floating fal fa-camera'></button>
        <small class='text-muted'>Add a profile photo</small>
      </div>
    </div>
  </cfif>

  <div class='modal fade' id='profile_modal' tabindex='-1' role='dialog' aria-hidden='true'>
    <div class='modal-dialog modal-dialog-centered modal-lg' role='document'>
      <div class='modal-content'>
        <div class='modal-header'>
          <h5 class='modal-title text-xs-center'>Update profile picture</h5>
          <button type='button' class='btn-close' data-bs-dismiss='modal' aria-label='Close'></button>
        </div>
        <div class='modal-body'>
          <div class='container-fluid'>
            <form method='post' enctype='multipart/form-data'>
              <div class='upload-container'>
                <div class='image-picker'>
                  <div class='row mb-3'>
                    <div class='col-12'>
                      <a class='btn btn-nmg mr-3 position-relative'>
                        <span>Upload Photo <i class='fal fa-upload'></i></span>
                        <input class='h-100 w-100 position-absolute' type='file' id='profile_input' value='Choose a file' accept='image/*'>
                      </a>
                      <a class='btn btn-nmg mr-3 position-relative' id='profile_remove' >
                        <span>Remove Profile Photo <i class='fal fa-trash'></i></span>
                      </a>
                    </div>
                  </div>
                  <div class='row mb-2'>
                    <div class='col-12'>
                      <h5>Uploads</h5>
                    </div>
                  </div>
                  <div class='row mb-3'>
                    <div id='image_roll' class='col-12 text-center thumbnail-sm'>
                      <cfloop array='#mUser.UserImages()#' item='mImage' index='idx'>
                        <img class='image-roll' src='#mImage.thumbnail_src()#' data-uiid='#mImage.encoded_key()#' style='#ifin(idx gt 6, "display:none")#' />
                      </cfloop>
                    </div>
                    <cfif mUser.UserImages().len() gt 6>
                      <div class='col-12 text-center mt-3' id='image_roll_more'>
                        <button type='button' class='btn btn-nmg w-100'>See more</button>
                      </div>
                    </cfif>
                  </div>
                </div>
                <div class='image-cropper profile-crop-wrapper d-none'>
                  <div id='upload_profile'></div>
                </div>
              </div>
            </form>
          </div>
        </div>
        <div id='modal_buttons' class='modal-footer d-none'>
          <button type='button' class='btn btn-nmg ml-auto' id='btnCancel'>Cancel</button>
          <button type='button' class='btn btn-nmg' id='btnSave'>Save</button>
        </div>
      </div>
    </div>
  </div>
</cfoutput>
