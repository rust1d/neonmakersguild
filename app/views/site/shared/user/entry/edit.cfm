<cfscript>
  dest = (mBlog.id()==1 && session.site.isA('admin')) ? 'blog' : 'user';

  if (form.keyExists('btnSubmit')) {
    param form.categories = '';
    param form.ben_released = false;

    if (len(form.get('bca_category'))) {
      qry = mBlog.category_search(bca_category: form.bca_category);
      if (qry.len()) {
        form.categories = form.categories.listAppend(qry.bca_bcaid);
      } else {
        mCategory = mBlog.category_build(form);
        if (mBlog.category_save(mCategory)) form.categories = form.categories.listAppend(mCategory.bcaid());
      }
    }

    mEntry.set(form);
    if (mEntry.safe_save()) {
      mEntry.BlogEntryCategories(replace: form.categories ?: '');
      mEntry.RelatedBlogEntries(replace: form.relatedEntries ?: '');
      flash.success('Your entry was saved.');
      router.redirect('#dest#/entry/list');
    }
  }

  param form.categories = mEntry.BlogEntryCategories().map(row => row.bec_bcaid()).toList();
  qryCats = mBlog.categories();
  mode = mEntry.new_record() ? 'Add' : 'Edit';

  mImages = mBlog.images(ratio: 2, maxrows: 10);
</cfscript>

<cfparam name='form.sendemail' default='true'>
<cfparam name='form.bca_category' default=''>

<script src='/assets/js/admin/blog/entry.js'></script>
<script src='/assets/js/image/select.js'></script>

<cfoutput>
  <div class='row mb-3'>
    <div class='col'>
      <form role='form' method='post' id='blogform' class='needs-validation' novalidate>
        <div class='card'>
          <div class='card-header bg-nmg'>
            <div class='row'>
              <div class='col fs-5'>#mode# Entry</div>
            </div>
          </div>
          <div class='card-body'>
            <div class='row g-3'>
              <div class='col-md-9'>
                <div class='row g-3'>
                  <div class='col-12'>
                    <label class='form-label required' for='ben_title'>Title</label>
                    <input type='text' class='form-control' name='ben_title' id='ben_title' value='#htmlEditFormat(mEntry.title())#' maxlength='100' required />
                  </div>
                  <div class='col-12'>
                    <label class='form-label required' for='ben_image'>Post Header Image URL <small>(2:1 ratio)</small></label>
                    <input type='text' class='form-control' name='ben_image' id='ben_image' value='#htmlEditFormat(mEntry.image())#' maxlength='150' required />
                    <div class='small text-muted'>All images must be hosted on this site. For best results, image should be 1200 x 600 pixels.</div>
                  </div>
                  <div class='col-12 col-md-6'>
                    <div id='image_header' class='aspect-2-1' style='background-image: url(#mEntry.image()#)'></div>
                  </div>
                  <cfif mImages.len()>
                    <div class='col-12 col-md-6'>
                      <div class='row ps-2'>
                        <cfloop array='#mImages#' item='mImage'>
                          <div class='col-sm-4 col-md-3 col-lg-2 p-1'>
                            <img class='w-100 img-thumbnail clipable' src='#mImage.thumbnail_src()#' data-clip='#mImage.image_src()#' onclick='image_header(this)' title='#mImage.filename()# -#mImage.dimensions()#' />
                          </div>
                        </cfloop>
                      </div>
                      <small class='text-muted'>Recent header images. Click image to copy url.</small>
                    </div>
                  </cfif>

                  <div class='col-12'>
                    <label class='form-label required' for='ben_body'>Post <small>(above fold)</small></label>
                    <textarea class='tiny-mce form-control' name='ben_body' id='ben_body'>#htmlEditFormat(mEntry.body())#</textarea>
                    <div class='small text-muted'>The post above the fold should be under 50 words and will be used when displaying a summary.</div>
                  </div>
                  <div class='col-12'>
                    <label class='form-label required' for='ben_morebody'>Post <small>(below fold)</small></label>
                    <textarea class='tiny-mce form-control' name='ben_morebody' id='ben_morebody'>#htmlEditFormat(mEntry.morebody())#</textarea>
                  </div>
                </div>
              </div>
              <div class='col-md-3'>
                <div class='row g-3'>
                  <div class='col-12'>
                    <label class='form-label' for='ben_alias'>Alias <small>(auto-generated)</small></label>
                    <input type='text' class='form-control' name='ben_alias' id='ben_alias' value='#mEntry.alias()#' maxlength='100' />
                  </div>
                  <div class='col-12'>
                    <label class='form-label required' for='ben_posted'>Post After</label>
                    <input type='text' class='form-control' name='ben_posted' id='ben_posted' value='#mEntry.posted()#' maxlength='20' required />
                    <div class='small text-muted'>yyyy-mm-dd hh24:mi</div>
                  </div>
                  <div class='col-12'>
                    <div class='form-check form-switch'>
                      <input class='form-check-input' type='checkbox' id='ben_released' name='ben_released' value='yes' #ifin(mEntry.released(), 'checked')#>
                      <label class='form-check-label' for='ben_released'>Released</label>
                    </div>
                  </div>

                  <div class='col-12'>
                    <label class='form-label required' for='categories'>Categories</label>
                    <select class='form-control' name='categories' id='categories' multiple='multiple' size='8'>
                      <cfloop array='#mBlog.categories()#' item='mCat'>
                        <option value='#mCat.bcaid()#' #ifin(listFind(form.categories, mCat.bcaid()), 'selected')#>#mCat.category()#</option>
                      </cfloop>
                    </select>
                  </div>
                  <div class='col-12'>
                    <label class='form-label' for='bca_category'>Add Category</label>
                    <input type='text' class='form-control' name='bca_category' id='bca_category' value='#htmlEditFormat(form.get('bca_category'))#' maxlength='50' />
                  </div>
                  <div class='col-12'>
                    <label class='form-label' for='imagesearch'>Images</label>
                    <div class='input-group input-group-sm'>
                      <input type='text' class='form-control' id='imagesearch' name='imagesearch' placeholder='search images...' maxlength='20' data-usid='#mBlog.encoded_key()#' />
                      <button class='btn btn-sm btn-nmg' type='button'><i class='fa fa-search'></i></button>
                    </div>
                    <small class='text-muted'>Click image to insert into post.</small>
                  </div>
                  <div class='col-12'>
                    <div id='imageselect' class='row g-0'>
                      <div class='col-4 p-1'><img class='w-100 img-thumbnail' src='/assets/images/profile_placeholder.png' /></div>
                    </div>
                  </div>
                </div>
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
</cfoutput>
