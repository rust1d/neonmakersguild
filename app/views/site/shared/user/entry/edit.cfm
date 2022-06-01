<cfscript>
  dest = (mBlog.id()==1 && session.site.isA('admin')) ? 'blog' : 'user';

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
          mCategory = mBlog.category_build({ bca_category: category });
          if (mBlog.category_save(mCategory)) categories.append(mCategory.bcaid());
        }
      }
    }

    mEntry.set(form);
    if (mEntry.safe_save()) {
      mEntry.BlogEntryCategories(replace: categories.toList());
      flash.success('Your entry was saved.');
      router.redirect('#dest#/entry/list');
    }
  }

  param form.ben_categories = mEntry.BlogEntryCategories().map(row => row.bec_bcaid()).toList();
  qryCats = mBlog.categories();
  mode = mEntry.new_record() ? 'Add' : 'Edit';

  mImages = mBlog.images(ratio: 2, maxrows: 12).rows;
</cfscript>

<script src='/assets/js/admin/blog/entry.js'></script>
<script src='/assets/js/image/select.js'></script>

<cfoutput>
  <div class='row'>
    <div class='col'>
      <form role='form' method='post' id='blogform' class='needs-validation' novalidate>
        <div class='card'>
          <div class='card-header bg-nmg'>
            <div class='row align-items-center'>
              <div class='col fs-5'>#mode# Entry</div>
              <div class='col-auto'>
                <a class='ms-2 blended-icon' data-bs-toggle='modal' data-bs-target='##helpModal'><i class='fas fa-xl fa-circle-question'></i></a>
              </div>
            </div>
          </div>
          <div class='card-body'>
            <div class='row g-2'>
              <div class='col-12'>
                <label class='form-label fs-4 required' for='ben_title'>Title</label>
                <a type='button' name='help_title' class='ms-2 blended-icon' data-bs-toggle='modal' data-bs-target='##helpModal'><i class='fas fa-circle-question'></i></a>
                <input type='text' class='form-control form-control-sm' name='ben_title' id='ben_title' value='#htmlEditFormat(mEntry.title())#' maxlength='100' required />
              </div>
              <div class='col-12'>
                <label class='form-label' for='ben_alias'>SEO Alias</label>
                <a type='button' name='help_alias' class='ms-2 blended-icon' data-bs-toggle='modal' data-bs-target='##helpModal'><i class='fas fa-circle-question'></i></a>
                <small class='text-muted ps-3'>auto-generated from title</small>
                <input type='text' class='form-control form-control-sm' name='ben_alias' id='ben_alias' value='#mEntry.alias()#' data-mode='#mode#' maxlength='100' />
              </div>
              <div class='col-12'>
                <label class='form-label fs-4 required' for='headersearch'>Header Image</label>
                <a type='button' name='help_image' class='ms-2 blended-icon' data-bs-toggle='modal' data-bs-target='##helpModal'><i class='fas fa-circle-question'></i></a>
                <small class='text-muted ps-3'>search and click thumbnail to set header image</small>
                <div class='input-group input-group-sm'>
                  <span class='input-group-text btn-nmg'><i class='fa fa-search'></i></span>
                  <input type='text' class='form-control' id='headersearch' name='headersearch' placeholder='type to search images...' maxlength='20' data-usid='#mBlog.encoded_key()#' />
                </div>
                <input type='text' class='form-control form-control-sm text-muted mt-2' name='ben_image' id='ben_image' value='#htmlEditFormat(mEntry.image())#' maxlength='150' readonly required />
                <div id='headerselect' class='row g-1 mt-1'>
                  <cfif mImages.len()==0><div class='col-sm-3 col-md-2 col-lg-1'><img class='w-100 img-thumbnail' src='/assets/images/profile_placeholder.png' /></div></cfif>
                  <cfloop array='#mImages#' item='mImage'>
                    <div class='col-3 col-md-2 col-xl-1'>
                      <img class='w-100 img-thumbnail border-success' src='#mImage.thumbnail_src()#' data-clip='#mImage.image_src()#' onclick='image_header(this)' title='#mImage.filename()# -#mImage.dimensions()#' />
                    </div>
                  </cfloop>
                </div>
              </div>
              <div class='col-12 col-lg-9'>
                <label class='form-label text-muted'><small>Images with a 2:1 width/height ratio and dimensions 1200 x 600 are recommended.</small></label>
                <div id='image_header' class='aspect-2-1 rounded' style='background-image: url(#mEntry.image()#)'></div>
              </div>
              <div class='col-12 col-lg-3'>
                <div class='row g-2'>
                  <div class='col-12 col-md-6 col-lg-12'>
                    <div class='row g-2'>
                      <div class='col-6'>
                        <label class='form-label required' for='ben_date'>Post Date</label>
                        <!--- <a type='button' name='help_posted' class='ms-2 blended-icon' data-bs-toggle='modal' data-bs-target='##helpModal'><i class='fas fa-circle-question'></i></a> --->
                        <input type='date' class='form-control form-control-sm' name='ben_date' id='ben_date' value='#mEntry.posted_date()#' maxlength='10' placeholder='YYYY-MM-DD' pattern='\d{4}-\d{2}-\d{2}' required />
                      </div>
                      <div class='col-6'>
                        <label class='form-label required' for='ben_time'>Post Time</label>
                        <input type='time' class='form-control form-control-sm' name='ben_time' id='ben_time' value='#mEntry.posted_time()#' maxlength='5' placeholder='HH24:MI' pattern='[0-9]{2}:[0-9]{2}' required />
                      </div>
                      <div class='col-6 col-md-12 col-lg-6'>
                        <label class='form-label mb-0' for='ben_released'>Released</label>
                        <!--- <a type='button' name='help_released' class='ms-2 blended-icon' data-bs-toggle='modal' data-bs-target='##helpModal'><i class='fas fa-circle-question'></i></a> --->
                        <div class='form-check form-switch form-control-lg'>
                          <input class='form-check-input mb-2' type='checkbox' id='ben_released' name='ben_released' value='yes' #ifin(mEntry.released(), 'checked')#>
                        </div>
                      </div>
                      <div class='col-6 col-md-12 col-lg-6'>
                        <label class='form-label mb-0' for='ben_comments'>Comments</label>
                        <!--- <a type='button' name='help_comments' class='ms-2 blended-icon' data-bs-toggle='modal' data-bs-target='##helpModal'><i class='fas fa-circle-question'></i></a> --->
                        <div class='form-check form-switch form-control-lg'>
                          <input class='form-check-input mb-2' type='checkbox' id='ben_comments' name='ben_comments' value='yes' #ifin(mEntry.comments(), 'checked')#>
                        </div>
                      </div>
                    </div>
                  </div>
                  <div class='col-12 col-md-6 col-lg-12'>
                    <label class='form-label required' for='ben_categories'>Categories</label>
                    <a type='button' name='help_categories' class='ms-2 blended-icon' data-bs-toggle='modal' data-bs-target='##helpModal'><i class='fas fa-circle-question'></i></a>
                    <div class='input-group input-group-sm'>
                      <input type='text' class='form-control' name='bca_category' id='bca_category' maxlength='50' />
                      <button type='button' id='btnAddCategory' class='input-group-text btn-nmg' title='Add Category'><i class='fal fa-plus'></i> &nbsp; Add</button>
                    </div>
                    <select class='form-control form-control-sm mt-1' name='ben_categories' id='ben_categories' multiple='multiple' title='ctrl+click to select multiple' size='7'>
                      <cfloop array='#mBlog.categories()#' item='mCat'>
                        <option value='#mCat.bcaid()#' #ifin(listFind(form.ben_categories, mCat.bcaid()), 'selected')#>#mCat.category()#</option>
                      </cfloop>
                    </select>
                  </div>
                </div>
              </div>
              <div class='col-12'>
                <label class='form-label fs-4 required mb-0' for='ben_body'>Post Summary</label>
                <a type='button' name='help_summary' class='ms-2 blended-icon' data-bs-toggle='modal' data-bs-target='##helpModal'><i class='fas fa-circle-question'></i></a>
                <div class='small text-muted mb-1'>
                  A summary of the entry. Should be under 50 words with no images or styling.
                </div>
                <textarea class='tiny-sum form-control' name='ben_body' rows='3' id='ben_body'>#htmlEditFormat(mEntry.body())#</textarea>
              </div>
              <div class='col-12'>
                <label class='form-label' for='imagesearch'>Image Search</label> <small class='text-muted ps-3'>click image to insert into post body</small>
                <div class='input-group input-group-sm'>
                  <span class='input-group-text btn-nmg'><i class='fa fa-search'></i></span>
                  <input type='text' class='form-control' id='imagesearch' name='imagesearch' placeholder='type to search images...' maxlength='20' data-usid='#mBlog.encoded_key()#' />
                </div>
                <div id='imageselect' class='row g-1 mt-1'>
                  <div class='col-3 col-md-2 col-xl-1'><img class='w-100 img-thumbnail' src='/assets/images/profile_placeholder.png' /></div>
                </div>
                <small class='text-muted'>Click image to insert into post.</small>
              </div>
              <div class='col-12'>
                <label class='form-label fs-4 required mb-0' for='ben_morebody'>Post Body</label>
                <a type='button' name='help_body' class='ms-2 blended-icon' data-bs-toggle='modal' data-bs-target='##helpModal'><i class='fas fa-circle-question'></i></a>
                <div class='small text-muted mb-1'>Full blog post containing html and images.</div>
                <textarea class='tiny-mce form-control' name='ben_morebody' rows='20' id='ben_morebody'>#htmlEditFormat(mEntry.morebody())#</textarea>
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
      </form>
    </div>
  </div>

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
        <!--- <div class='modal-footer'>
          <button type='button' class='btn btn-nmg' data-bs-dismiss='modal'>Close</button>
        </div> --->
      </div>
    </div>
  </div>
</cfoutput>
