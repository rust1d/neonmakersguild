
<cfscript>
  mPage = mBlog.page_find_or_create(router.decode('bpaid'));

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

    mPage.set(form);
    if (mPage.safe_save()) {
      mPage.BlogPagesCategories(replace: form.categories ?: '');
      flash.success('Your page was saved.');
      router.redirect('blog/page/list');
    }
  }

  param form.categories = mPage.BlogPagesCategories().map(row => row.bpc_bcaid()).toList();
  qryCats = new app.models.BlogCategories().search();
  mode = mPage.new_record() ? 'Add' : 'Edit';
</cfscript>

<cfparam name='form.bca_category' default=''>

<script src='/assets/js/admin/blog/page.js'></script>

<cfoutput>
  <div class='row mb-3'>
    <div class='col'>
      <form role='form' method='post' id='blogform'>
        <div class='card'>
          <div class='card-header btn-nmg'>
            <div class='row'>
              <div class='col fs-5'>#mode# Page</div>
            </div>
          </div>
          <div class='card-body'>
            <div class='row mt-3'>
              <div class='col-md-9'>
                <div class='row g-3'>
                  <div class='col-12'>
                    <label class='form-label required' for='bpa_title'>Title</label>
                    <input type='text' class='form-control' name='bpa_title' id='bpa_title' value='#htmlEditFormat(mPage.title())#' maxlength='100' required />
                  </div>
                  <div class='col-12'>
                    <label class='form-label required' for='bpa_body'>Body</label>
                    <textarea class='tiny-mce form-control' name='bpa_body' id='bpa_body'>#htmlEditFormat(mPage.body())#</textarea>
                  </div>
                </div>
              </div>
              <div class='col-md-3'>
                <div class='row g-3'>
                  <div class='col-12'>
                    <label class='form-label' for='bpa_alias'>Alias</label>
                    <input type='text' class='form-control' name='bpa_alias' id='bpa_alias' value='#mPage.alias()#' maxlength='100' />
                  </div>
                  <div class='col-12'>
                    <label class='form-label required' for='categories'>Categories</label>
                    <select class='form-control' name='categories' id='categories' multiple='multiple' size='8'>
                      <cfloop query='qryCats'>
                        <option value='#bca_bcaid#' #ifin(listFind(form.categories, bca_bcaid), 'selected')#>#bca_category#</option>
                      </cfloop>
                    </select>
                  </div>
                  <cfif mBlog.isAuthorized('AddCategory')>
                    <div class='col-12'>
                      <label class='form-label' for='bca_category'>Add Category</label>
                      <input type='text' class='form-control' name='bca_category' id='bca_category' value='#htmlEditFormat(form.get('bca_category'))#' maxlength='50' />
                    </div>
                  </cfif>
                  <div class='col-12'>
                    <div class='input-group'>
                      <span class='input-group-text btn-nmg'>Search Images</span>
                      <input id='imagesearch' type='text' class='form-control' placeholder='Search' maxlength='20' data-usid='#mBlog.encoded_key()#'>
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
                <a href='#router.href('blog/page/list')#' class='btn btn-nmg-cancel'>Cancel</a>
              </div>
            </div>
          </div>
        </div>
      </form>
    </div>
  </div>
</cfoutput>
