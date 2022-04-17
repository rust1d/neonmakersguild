<cfscript>
  dest = (mBlog.id()==1 && session.site.isA('admin')) ? 'blog' : 'user';

  if (form.keyExists('btnSubmit')) {
    param form.categories = '';
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
</cfscript>

<cfparam name='form.sendemail' default='true'>
<cfparam name='form.bca_category' default=''>

<script src='/assets/js/admin/blog/entry.js'></script>

<cfoutput>
  <div class='row mb-3'>
    <div class='col'>
      <form role='form' method='post' id='blogform'>
        <div class='card'>
          <div class='card-header btn-nmg'>
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
                    <label class='form-label required' for='ben_body'>Post (above fold)</label>
                    <textarea class='tiny-mce form-control' name='ben_body' id='ben_body'>#htmlEditFormat(mEntry.body())#</textarea>
                  </div>
                  <div class='col-12'>
                    <label class='form-label required' for='ben_morebody'>Post (below fold)</label>
                    <textarea class='tiny-mce form-control' name='ben_morebody' id='ben_morebody'>#htmlEditFormat(mEntry.morebody())#</textarea>
                  </div>
                </div>
              </div>
              <div class='col-md-3'>
                <div class='row g-3'>
                  <div class='col-12'>
                    <label class='form-label' for='ben_alias'>Alias</label>
                    <input type='text' class='form-control' name='ben_alias' id='ben_alias' value='#mEntry.alias()#' maxlength='100' />
                  </div>
                  <div class='col-12'>
                    <label class='form-label required' for='ben_posted'>Posted</label>
                    <input type='text' class='form-control' name='ben_posted' id='ben_posted' value='#mEntry.posted()#' maxlength='20' required />
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
                <button type='submit' name='btnCancel' id='btnCancel' class='btn btn-nmg-cancel' onClick='return confirm("Are you sure you want to cancel this entry?")'>Cancel</button>
              </div>
            </div>
          </div>
        </div>
      </form>
    </div>
  </div>
</cfoutput>
