<cfscript>
  param mUserBlog = mBlog;

  dest = (mUserBlog.id()==1 && session.site.admin()) ? 'blog' : 'user';

  function save_images(required BlogEntries mBE) {
    var flds = form.fieldnames.listToArray().filter(fld => fld.left(4)=='img_');
    if (flds.isEmpty()) return;

    for (var fld in flds) {
      mUI = mUser.UserImages(build: { filefield: fld });
      if (mUI.safe_save()) {
        var params = {
          bei_benid:  mBE.benid(),
          bei_uiid:  mUI.uiid()
        }
        if (form.keyExists('cap_#fld#')) params.bei_caption = form['cap_#fld#'];
        mBE.BlogEntryImages(build: params).safe_save();
      }
    }
  }

  if (form.keyExists('btnSubmit')) {
    param form.ben_categories = '';
    param form.ben_released = false;
    param form.ben_comments = false;
    form.ben_posted = ParseDateTime(form.ben_date & ' ' & form.ben_time);

    categories = [];
    for (category in form.ben_categories) {
      if (isNumeric(category)) {
        categories.append(category);
      } else {
        qry = mBlog.category_search(bca_category: category);
        if (qry.len()) {
          categories.append(qry.bca_bcaid);
        } else {
          mCategory = mUserBlog.category_build({ bca_category: category });
          if (mUserBlog.category_save(mCategory)) categories.append(mCategory.bcaid());
        }
      }
    }

    mEntry.set(form);
    if (mEntry.safe_save()) {
      save_images(mEntry);
      mEntry.BlogEntryCategories(replace: categories.toList());
      flash.success('Your entry was saved.');
      router.redirect('#dest#/entry/list');
    }
  }

  param form.ben_categories = mEntry.BlogEntryCategories().map(row => row.bec_bcaid()).toList();
  mode = mEntry.new_record() ? 'Add' : 'Edit';
</cfscript>

<cfset include_js('assets/js/admin/blog/entry.js') />
<cfset include_js('assets/js/forums/images.js') />
<cfset router.include('forum/_image_dropdown') />

<cfoutput>
  <form role='form' method='post' id='blogform' class='needs-validation' novalidate enctype='multipart/form-data'>
    <input type='hidden' name='ben_alias' id='ben_alias' value='#mEntry.alias()#' data-mode='#mode#' maxlength='100' />
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
                <label class='form-label fs-5 required' for='ben_title'>Post Title</label>
                <a name='help_title' class='ms-2 blended-icon' data-bs-toggle='modal' data-bs-target='##helpModal'><i class='fas fa-circle-question'></i></a>
                <input type='text' class='form-control form-control-lg' name='ben_title' id='ben_title' value='#htmlEditFormat(mEntry.title())#' maxlength='100' required />
              </div>
              <div class='col-12'>
                <label class='form-label fs-5 required mb-0' for='ben_body'>Post Body</label>
                <a name='help_body' class='ms-2 blended-icon' data-bs-toggle='modal' data-bs-target='##helpModal'><i class='fas fa-circle-question'></i></a>
                <textarea class='tiny-forum form-control' name='ben_body' rows='15' id='ben_body'>#htmlEditFormat(mEntry.body())#</textarea>
              </div>
              <div class='col-12'>
                <div id='photo_roll' class='row g-1 mb-2 position-relative' data-sortable>
                  <button type='button' id='btnEditCaptions' class='btn btn-sm btn-nmg w-120px #ifin(mEntry.UserImages().len() GT 1, 'displayed')#' data-bs-toggle='modal' data-bs-target='##editAllModal'>Edit all</button>
                  <cfloop array='#mEntry.BlogEntryImages()#' item='mBEI'>
                    <cfset mUI = mBEI.UserImage() />
                    <div class='col-3 col-xl-2 position-relative'>
                      <img data-pkid='#mUI.encoded_key()#' class='w-100 img-thumbnail' data-caption='cap_#mUI.encoded_key()#' alt='#mUI.filename()#' src='#mUI.thumbnail_src()#' />
                      <button type='button' class='btn-delete-img btn-nmg-delete'>&times;</button>
                      <input type='hidden' id='cap_#mUI.encoded_key()#' name='cap_#mUI.encoded_key()#' value='#mBEI.caption()#' />
                    </div>
                  </cfloop>
                </div>
              </div>
              <div class='col-12 col-lg-6'>
                <label class='form-label fs-5 mb-0' for='ben_morebody'>Post Summary</label>
                <a name='help_summary' class='ms-2 blended-icon' data-bs-toggle='modal' data-bs-target='##helpModal'><i class='fas fa-circle-question'></i></a>
                <textarea class='form-control' name='ben_morebody' rows='3' id='ben_morebody'>#htmlEditFormat(mEntry.morebody())#</textarea>
                <div class='form-text text-small'>
                  Optional. Enter a short paragraph (~50 words) summarizing your blog post. This is displayed in compact layouts. If you do not enter one, it will be generated from the start of your post.
                </div>
              </div>
              <div class='col-12 col-md-6 col-lg-3'>
                <div class='row g-3'>
                  <div class='col-12'>
                    <label class='form-label required' for='ben_date'>Post Date/Time</label>
                    <div class='input-group'>
                      <input type='date' class='form-control' name='ben_date' id='ben_date' value='#mEntry.posted_date()#' maxlength='10' placeholder='YYYY-MM-DD' pattern='\d{4}-\d{2}-\d{2}' required />
                      <input type='time' class='form-control' name='ben_time' id='ben_time' value='#mEntry.posted_time()#' maxlength='5' placeholder='HH24:MI' pattern='[0-9]{2}:[0-9]{2}' required />
                    </div>
                    <div class='form-text text-small'>Post is not public until after this date</div>
                  </div>
                  <div class='col-12'>
                    <div class='form-check form-switch'>
                      <input class='form-check-input toggle-switch' type='checkbox' role='switch' id='ben_released' name='ben_released' value='yes' #ifin(mEntry.released(), 'checked')#>
                      <label class='form-check-label' for='ben_released'>Post Released</label>
                    </div>
                    <div class='form-text text-small'>Post is not public unless selected</div>
                  </div>
                  <div class='col-12'>
                    <div class='form-check form-switch'>
                      <input class='form-check-input toggle-switch' type='checkbox' role='switch' id='ben_comments' name='ben_comments' value='yes' #ifin(mEntry.comments(), 'checked')#>
                      <label class='form-check-label' for='ben_comments'>Allow Comments</label>
                    </div>
                    <div class='form-text text-small'>Comments are not allowed unless selected</div>
                  </div>
                </div>
              </div>
              <div class='col-12 col-md-6 col-lg-3'>
                <label class='form-label required' for='ben_categories'>Categories</label>
                <a name='help_categories' class='ms-2 blended-icon' data-bs-toggle='modal' data-bs-target='##helpModal'><i class='fas fa-circle-question'></i></a>
                <div class='input-group input-group-sm'>
                  <input type='text' class='form-control' name='bca_category' id='bca_category' maxlength='50' />
                  <button type='button' id='btnAddCategory' class='input-group-text btn-nmg' title='Add Category'><i class='fa-solid fa-fw fa-plus'></i> &nbsp; Add</button>
                </div>
                <select class='form-control form-control-sm mt-1' name='ben_categories' id='ben_categories' multiple='multiple' title='ctrl+click to select multiple' size='7'>
                  <cfloop array='#mUserBlog.categories()#' item='mCat'>
                    <option value='#mCat.bcaid()#' #ifin(listFind(form.ben_categories, mCat.bcaid()), 'selected')#>#mCat.category()#</option>
                  </cfloop>
                </select>
              </div>
            </div>
            <div class='row mt-5'>
              <div class='col text-center'>
                <button type='submit' name='btnSubmit' id='btnSubmit' class='btn btn-nmg'>Save</button>
                <button type='button' name='btnPreview' id='btnPreview' class='btn btn-nmg'>Preview</button>
                <button type='submit' name='btnCancel' id='btnCancel' class='btn btn-nmg-cancel'>Cancel</button>
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
          <button type='button' class='btn btn-nmg' data-bs-dismiss='modal' aria-label='Close'><i class='fas fa-times'></i></button>
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
