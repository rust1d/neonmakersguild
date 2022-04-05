<script src='/assets/js/user/profile_image.js'></script>

<cfoutput>
  <section class='container'>
    <h4>Photos</h4>
    <div class='row mb-3'>
      <div id='image_roll' class='col-auto text-center thumbnail-md'>
        <cfloop array='#mUser.UserImages()#' item='mImage' index='idx'>
          <span class='position-relative dropdown' id='img_#mImage.uiid()#'>
            <img src='#mImage.thumbnail_src()#' class='img-thumbnail' />
            <span class='dropdown' data-uiid='#mImage.uiid()#'>
              <button class='image-menu-btn btn btn-nmg btn-sm btn-outline-dark btn-floating' data-bs-toggle='dropdown'>
                <i class='fal fa-pencil' aria-hidden='true'></i>
              </button>
              <ul class='dropdown-menu pull-right'>
                <li><button name='btnEdit' class='dropdown-item'><i class='fa fa-user-circle'></i> Make Profile</button></li>
                <li><button class='dropdown-item' data-bs-toggle='modal' data-bs-target='##image_delete'><i class='fa fa-trash'></i> Delete</button></li>
              </ul>
            </span>
          </span>
        </cfloop>
      </div>
    </div>

    <div class='modal fade' id='image_delete' tabindex='-1' role='dialog' aria-hidden='true'>
      <div class='modal-dialog'>
        <div class='modal-content'>
          <div class='modal-header'>
            <h5 class='modal-title text-xs-center'>Delete Photo</h5>
            <button type='button' class='btn-close' data-bs-dismiss='modal' aria-label='Close'></button>
          </div>
          <div class='modal-body'>Are you sure you want to delete this photo?</div>
          <div class='modal-footer'>
            <button type='button' class='btn bg-nmg text-white ml-auto' data-bs-dismiss='modal'>Cancel</button>
            <button name='btnDelete' type='button' class='btn bg-nmg text-white ml-auto' data-bs-dismiss='modal'>Delete</button>
          </div>
        </div>
      </div>
    </div>

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
                  <div class='profile-crop-wrapper'>
                    <div id='upload_profile'></div>
                  </div>
                </div>
              </form>
            </div>
          </div>
          <div class='modal-footer'>
            <button type='button' class='btn bg-nmg text-white ml-auto' data-bs-dismiss='modal'>Cancel</button>
            <button type='button' class='btn bg-nmg text-white' id='btnSave'>Save</button>
          </div>
        </div>
      </div>
    </div>
  </section>
</cfoutput>
