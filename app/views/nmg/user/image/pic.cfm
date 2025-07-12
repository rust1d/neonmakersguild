<cfset include_js('assets/js/image/profile.js') />

<cfoutput>
  #router.include('shared/user/image/_crop_modal', { aspect: false })#

  <cfif mUser.profile_image().exists()>
    <div class='row mb-3'>
      <div class='col-auto'>
        <div class='position-relative d-inline-block'>
          <img class='img-thumbnail' id='profile_image' src='#mUser.profile_image().src()#' />
          <button type='button' data-bs-target='##profile_modal' data-bs-toggle='modal' class='btn btn-icon bottom-right btn-nmg btn-outline-dark'>
            <i class='fa-solid fa-photo-film'></i>
          </button>
        </div>
      </div>
    </div>
  <cfelse>
    <div class='row mb-3'>
      <div class='col-12'>
        <div class='position-relative d-inline-block'>
          <img class='img-thumbnail' id='profile_image' src='#mUser.profile_image().src()#' />
          <button type='button' data-bs-target='##profile_modal' data-bs-toggle='modal' class='btn btn-icon bottom-right btn-nmg btn-outline-dark'>
            <i class='fa-solid fa-camera'></i>
          </button>
        </div>
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
                        <span>Upload Photo <i class='fa-solid fa-fw fa-upload'></i></span>
                        <input class='h-100 w-100 position-absolute top-0 start-0 opacity-0' type='file' id='profile_input' value='Choose a file' accept='image/*'>
                      </a>
                      <a class='btn btn-nmg mr-3 position-relative' id='profile_remove' >
                        <span>Remove Profile Photo <i class='fa-solid fa-fw fa-trash'></i></span>
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
                <div class='profile-crop-wrapper d-none'>
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
