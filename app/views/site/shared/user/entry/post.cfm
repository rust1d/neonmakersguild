<cfscript>
  param mUserBlog = mBlog;
  variables.dest = (mUserBlog.id()==1 && session.site.admin()) ? 'blog' : 'user';

  if (form.keyExists('btnSubmit')) {
    mEntry = new app.services.user.Post().create(mUser);
    if (mEntry.persisted()) {
      if (variables.dest=='blog') router.redirect('blog/entry/list'); // ADMIN
      router.go(mEntry.seo_link());
    }
  }

  mode = mEntry.new_record() ? 'Add' : 'Edit';
</cfscript>

<cfset include_js('assets/js/admin/blog/entry.js') />
<cfset include_js('assets/js/forums/images.js') />
<cfset router.include('shared/partials/image_dropdown') />
<cfset router.include('shared/partials/process_overlay') />

<cfoutput>
  <form role='form' method='post' id='blogform' class='needs-validation' novalidate enctype='multipart/form-data'>
    <input type='hidden' name='beiids' />
    <input type='file' id='filePicker' accept='image/*' multiple class='d-none' />

    <div class='row'>
      <div class='col'>
        <div class='card'>
          <div class='card-header bg-nmg'>
            <div class='row align-items-center'>
              <div class='col fs-5'>#mode# Blog Post</div>
              <div class='col-auto'>
                <a class='ms-2 blended-icon' data-bs-toggle='modal' data-bs-target='##helpModal'><i class='fas fa-xl fa-circle-question'></i></a>
              </div>
            </div>
          </div>
          <div class='card-body'>
            <div class='row g-3'>
              <div class='col-12'>
                <label class='form-label required' for='ben_title'>Post Title</label>
                <input type='text' class='form-control form-control-lg' name='ben_title' id='ben_title' value='#htmlEditFormat(mEntry.title())#' maxlength='100' required />
              </div>
              <div class='col-12'>
                <label class='form-label required' for='ben_body'>Post Body</label>
                <textarea class='tiny-forum form-control' name='ben_body' rows='15' id='ben_body'>#htmlEditFormat(mEntry.body())#</textarea>
              </div>
              <div class='col-12'>
                <div id='photo_roll' class='row g-1 mb-2 position-relative' data-sortable>
                  <button type='button' id='btnEditCaptions' class='btn btn-sm btn-nmg w-120px #ifin(mEntry.UserImages().len() GT 1, 'displayed')#' data-bs-toggle='modal' data-bs-target='##editAllModal'>Edit all</button>
                  <cfloop array='#mEntry.BlogEntryImages()#' item='mBEI'>
                    <cfset mUI = mBEI.UserImage() />
                    <div class='col-3 col-xl-2 position-relative text-center'>
                      <img data-pkid='#mUI.encoded_key()#' class='img-fluid' data-caption='bei_caption_#mBEI.encoded_key()#' alt='#mUI.filename()#' src='#mUI.thumbnail_src()#' />
                      <button type='button' name='btnImgDelete' data-pkid='#mBEI.encoded_key()#' class='btn-close btn-close-delete'></button>
                      <input type='hidden' id='bei_caption_#mBEI.encoded_key()#' name='bei_caption_#mBEI.encoded_key()#' value='#mBEI.caption()#' />
                    </div>
                  </cfloop>
                </div>
              </div>
              <div class='col-12 col-lg-9'>
                <label class='form-label' for='ben_morebody'>Post Summary</label>
                <textarea class='form-control' name='ben_morebody' rows='3' id='ben_morebody'>#htmlEditFormat(mEntry.morebody())#</textarea>
                <div class='form-text smaller'>
                  A short paragraph summarizing your blog post. This is displayed in the member stream. If you do not enter one, it will be generated.
                </div>
              </div>
              <div class='col-12 col-lg-3'>
                <div class='row g-3'>
                  <div class='col-12'>
                    <label class='form-label required' for='ben_date'>Post Date/Time</label>
                    <div class='input-group'>
                      <input type='date' class='form-control' name='ben_date' id='ben_date' value='#mEntry.posted_date()#' maxlength='10' placeholder='YYYY-MM-DD' pattern='\d{4}-\d{2}-\d{2}' required />
                      <input type='time' class='form-control' name='ben_time' id='ben_time' value='#mEntry.posted_time()#' maxlength='5' placeholder='HH24:MI' pattern='[0-9]{2}:[0-9]{2}' required />
                    </div>
                    <div class='form-text smaller'>Post is not be displayed until this date</div>
                  </div>
                  <div class='col-12'>
                    <div class='form-check form-switch form-check-sm'>
                      <input class='form-check-input toggle-switch' type='checkbox' role='switch' id='ben_released' name='ben_released' value='yes' #ifin(mEntry.released(), 'checked')# switch />
                      <label class='form-check-label' for='ben_released'>Post Released</label>
                    </div>
                    <div class='form-text smaller'>Post is not displayed unless selected</div>
                  </div>
                  <div class='col-12'>
                    <div class='form-check form-switch'>
                      <input class='form-check-input toggle-switch' type='checkbox' role='switch' id='ben_comments' name='ben_comments' value='yes' #ifin(mEntry.comments(), 'checked')# switch />
                      <label class='form-check-label' for='ben_comments'>Allow Comments</label>
                    </div>
                    <div class='form-text smaller'>Comments are not allowed unless selected</div>
                  </div>
                </div>
              </div>
            </div>
            <div class='row mt-5'>
              <div class='col text-center'>
                <button type='submit' name='btnSubmit' id='btnSubmit' class='btn btn-nmg'>Save</button>
                <button type='button' name='btnPreview' id='btnPreview' class='btn btn-nmg'>Preview</button>
                <button type='button' name='btnCancel' id='btnCancel' data-list='user/entry/list' class='btn btn-nmg-cancel'>Cancel</button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <div class='modal fade' id='editAllModal' data-bs-backdrop='static' tabindex='-1' aria-labelledby='editAllModalLabel' aria-hidden='true'>
      <div class='modal-dialog modal-lg modal-dialog-scrollable'>
        <div class='modal-content'>
          <div class='modal-header'>
            <h5 class='modal-title' id='editAllModalLabel'>Photos</h5>
            <button type='button' class='btn-close' data-bs-dismiss='modal' aria-label='Close'></button>
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
  </form>

  <div class='modal fade' id='helpModal' tabindex='-1' aria-labelledby='helpModalLabel' aria-hidden='true'>
    <div class='modal-dialog border-nmg border rounded modal-lg modal-dialog-scrollable'>
      <div class='modal-content bg-nmg'>
        <div class='modal-header'>
          <h5 class='modal-title' id='helpModalLabel'>Blog Entry Help</h5>
          <button type='button' class='btn-close' data-bs-dismiss='modal' aria-label='Close'></button>
        </div>
        <div class='modal-body'>
          <div class='container-fluid'>
            #router.include('shared/help/entry')#
          </div>
        </div>
      </div>
    </div>
  </div>
</cfoutput>
