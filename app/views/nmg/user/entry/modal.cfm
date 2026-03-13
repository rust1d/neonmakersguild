<cfset include_js('assets/js/admin/blog/pop_post.js') />
<cfset include_js('assets/js/forums/images.js') />
<cfset router.include('shared/partials/image_dropdown') />
<cfset router.include('shared/partials/process_overlay') />

<cfoutput>
  <div class='neon-red rounded d-flex align-items-center'>
    <img class='avatar-circle flex-shrink-0 ms-3' src='#session.user.profile_image().src()#' />
    <div class='d-flex flex-column flex-grow-1 p-2 gap-2 justify-content-center'>
      <a class='btn btn-faux-field rounded-pill' data-bs-toggle='modal' data-bs-target='##post_modal'>
        <span class='blinking me-1'>&##x2502;</span>What are you working on, #session.user.UserProfile().firstname()#?
      </a>
      <div class='d-flex gap-2 justify-content-center'>
        <a class='btn btn-sm btn-outline-secondary rounded-pill px-3' data-bs-toggle='modal' data-bs-target='##post_modal'>
          <i class='fa-regular fa-image me-1'></i>Photo
        </a>
        <a class='btn btn-sm btn-outline-secondary rounded-pill px-3' data-bs-toggle='modal' data-bs-target='##post_modal'>
          <i class='fa-regular fa-pen-to-square me-1'></i>Story
        </a>
      </div>
    </div>
  </div>

  <div class='modal fade' id='post_modal' tabindex='-1'>
    <div class='modal-dialog modal-dialog-scrollable modal-fullscreen-md-down modal-xl'>
      <div id='modal_entry' class='modal-content'>
        <div class='modal-header px-3 p-2'>
          <div class='d-flex align-items-center gap-2'>
            <img class='avatar-circle' style='width:36px;min-width:36px' src='#session.user.profile_image().src()#' />
            <div>
              <h5 class='modal-title smaller mb-0'>Create Post</h5>
              <small class='text-muted'>#session.user.UserProfile().name()#</small>
            </div>
          </div>
          <button type='button' class='btn-close smaller' data-bs-dismiss='modal'></button>
        </div>
        <div class='modal-body'>
          <form method='post' action='#router.href('user/entry/edit')#' id='post_form' class='needs-validation' novalidate enctype='multipart/form-data'>
            <input type='file' id='filePicker' accept='image/*' multiple class='d-none' />
            <input type='hidden' name='post_form' value='1' />
            <div class='mb-3'>
              <input type='text' class='form-control form-control-lg border-0 border-bottom rounded-0 ps-2 fw-semibold' id='ben_title' name='ben_title' placeholder='Give your post a title...' maxlength='100' required />
            </div>
            <div class='mb-3'>
              <textarea class='tiny-forum form-control' id='ben_body' name='ben_body' rows='8'></textarea>
            </div>
            <div id='photo_roll' class='row g-1 mb-2 position-relative' data-sortable>
              <button type='button' id='btnEditCaptions' class='btn btn-sm btn-nmg w-120px'>Edit all</button>
            </div>
            <div class='smaller'>
              <div class='row g-3'>
                <div class='col-md-6'>
                  <div class='d-flex justify-content-between align-items-center content-card'>
                    <label class='form-label fw-semibold mb-0 flex-grow-1 pe-3' for='ben_comments'>Comment options</label>
                    <div class='d-flex align-items-center gap-2'>
                      <label class='form-label mb-0' for='ben_comments'>Allow Comments</label>
                      <div class='form-check form-switch mb-0'>
                        <input class='form-check-input' type='checkbox' id='ben_comments' name='ben_comments' value='yes'>
                      </div>
                    </div>
                  </div>
                </div>
                <div class='col-md-6'>
                  <div class='content-card'>
                    <div class='d-flex justify-content-between align-items-center'>
                      <label class='form-label fw-semibold mb-0 flex-grow-1 pe-3' for='ben_schedule'>Scheduling options</label>
                      <div class='d-flex align-items-center gap-2'>
                        <label class='form-label mb-0' for='ben_schedule'>Set date and time</label>
                        <div class='form-check form-switch mb-0'>
                          <input class='form-check-input' type='checkbox' id='ben_schedule' name='ben_schedule' value='1'>
                        </div>
                      </div>
                    </div>
                    <div id='schedule_options' class='mt-2 pt-2 border-top' style='display: none;'>
                      <label for='ben_date' class='form-label'>Release Date</label>
                      <div class='input-group input-group-sm max-w-300px'>
                        <input type='date' class='form-control' name='ben_date' id='ben_date' value='#now().format('yyyy-mm-dd')#' maxlength='10' placeholder='YYYY-MM-DD' pattern='\d{4}-\d{2}-\d{2}' required />
                        <input type='time' class='form-control' name='ben_time' id='ben_time' value='#now().format('HH:nn')#' maxlength='5' pattern='[0-9]{2}:[0-9]{2}' required />
                      </div>
                      <div class='form-text mt-2'>
                        Select a date and time in the future to publish your post.
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </form>
        </div>
        <div class='modal-footer'>
          <button type='submit' form='post_form' name='btnLater' class='btn btn-outline-secondary rounded-pill px-4' title='save but do not release'>Finish Later</button>
          <button type='submit' form='post_form' name='btnPublish' class='btn btn-nmg neon-glow rounded-pill px-4 fw-semibold' title='save and release'>
            <i class='fa-regular fa-paper-plane me-1'></i>Publish
          </button>
        </div>
      </div>
      <div id='modal_captions' class='modal-content d-none'>
        <div class='modal-header px-3 p-2'>
          <h5 class='modal-title smaller'>Edit Photo Captions</h5>
        </div>
        <div class='modal-body'>
          <div id='captions' class='row g-3'></div>
        </div>
        <div class='modal-footer'>
          <button type='button' id='btnSaveCaptions' class='btn btn-nmg'>Done</button>
        </div>
      </div>
    </div>
  </div>
</cfoutput>
