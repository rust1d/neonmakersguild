
<cfscript>
  mPage = mBlog.page_find_or_create(router.decode('bpaid'));

  if (form.keyExists('btnSubmit')) {
    param form.bpa_categories = '';

    categories = [];
    for (category in form.bpa_categories) {
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

    mPage.set(form);
    if (mPage.safe_save()) {
      mPage.BlogPagesCategories(replace: categories.toList());
      flash.success('Your page was saved.');
      router.redirect('blog/page/list');
    }
  }

  param form.bpa_categories = mPage.BlogPagesCategories().map(row => row.bpc_bcaid()).toList();
  qryCats = mBlog.categories();
  mode = mPage.new_record() ? 'Add' : 'Edit';
</cfscript>

<cfparam name='form.bca_category' default=''>

<script src='/assets/js/admin/blog/page.js'></script>
<script src='/assets/js/image/select.js'></script>

<cfoutput>
  <div class='row mb-3'>
    <div class='col'>
      <form role='form' method='post' id='blogform'>
        <div class='card'>
          <div class='card-header bg-nmg'>
            <div class='row'>
              <div class='col fs-5'>#mode# Page</div>
            </div>
          </div>
          <div class='card-body'>
            <div class='row g-3'>
              <div class='col-md-8 col-lg-9'>
                <div class='row g-3'>
                  <div class='col-12'>
                    <label class='form-label required' for='bpa_title'>Title</label>
                    <input type='text' class='form-control' name='bpa_title' id='bpa_title' value='#htmlEditFormat(mPage.title())#' maxlength='100' required />
                  </div>
                  <div class='col-12'>
                    <label class='form-label' for='bpa_alias'>SEO Alias</label> <small class='text-muted ps-3'>auto-generated from title if left blank</small>
                    <input type='text' class='form-control' name='bpa_alias' id='bpa_alias' value='#mPage.alias()#' maxlength='100' />
                  </div>
                </div>
              </div>
              <div class='col-md-4 col-lg-3'>
                <div class='row g-3'>
                  <div class='col-12'>
                    <label class='form-label' for='bpa_categories'>Categories</label>
                    <div class='input-group input-group-sm'>
                      <input type='text' class='form-control' name='bca_category' id='bca_category' maxlength='50' />
                      <button type='button' id='btnAddCategory' class='input-group-text btn-nmg' title='Add Category'><i class='fal fa-plus'></i> &nbsp; Add</button>
                    </div>
                    <select class='form-control form-control-sm mt-1' name='bpa_categories' id='bpa_categories' multiple='multiple' title='ctrl+click to select multiple' size='5'>
                      <cfloop array='#mBlog.categories()#' item='mCat'>
                        <option value='#mCat.bcaid()#' #ifin(listFind(form.bpa_categories, mCat.bcaid()), 'selected')#>#mCat.category()#</option>
                      </cfloop>
                    </select>
                  </div>
                </div>
              </div>
              <div class='col-12'>
                <label class='form-label' for='imagesearch'>Image Search</label> <small class='text-muted ps-3'>search and click image to insert</small>
                <div class='input-group input-group-sm'>
                  <span class='input-group-text btn-nmg'><i class='fa fa-search'></i></span>
                  <input type='text' class='form-control' id='imagesearch' name='imagesearch' placeholder='type to search images...' maxlength='20' data-usid='#mBlog.encoded_key()#' />
                </div>
                <div id='imageselect' class='row g-1 mt-1'>
                  <div class='col-3 col-md-2 col-xl-1'><img class='w-100 img-thumbnail' src='#application.urls.cdn#/assets/images/profile_placeholder.png' /></div>
                </div>
                <small class='text-muted'>Click image to insert into post.</small>
              </div>
              <div class='col-12'>
                <label class='form-label required' for='bpa_body'>Body</label>
                <textarea class='tiny-mce form-control' rows='15' name='bpa_body' id='bpa_body'>#htmlEditFormat(mPage.body_cdn())#</textarea>
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
