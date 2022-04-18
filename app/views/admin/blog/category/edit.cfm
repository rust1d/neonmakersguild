

<cfscript>
  bcaid = router.decode('bcaid');
  if (!mBlog.isAuthorized('AddCategory') && bcaid==0) {
    flash.warning('Sorry you are not authorized to add categories.');
    router.redirect('blog/category/list');
  }

  mCategory = mBlog.category_find_or_create(bcaid);

  if (form.keyExists('btnSubmit')) {
    mCategory.set(form);
    if (mBlog.category_save(mCategory)) {
      flash.success('Your Category was saved.');
      router.redirect('blog/category/list');
    }
  }

  mode = mCategory.new_record() ? 'Add' : 'Edit';
</cfscript>

<cfoutput>
  <div class='row mb-3'>
    <div class='col'>
      <form role='form' method='post' enctype='multipart/form-data'>
        <div class='card'>
          <div class='card-header bg-nmg'>
            <div class='row'>
              <div class='col fs-5'>#mode# Category</div>
            </div>
          </div>
          <div class='card-body'>
            <div class='row g-3'>
              <div class='col-12'>
                <label class='form-label required' for='bca_category'>Category</label>
                <input type='text' class='form-control' name='bca_category' id='bca_category' value='#htmlEditFormat(mCategory.category())#' maxlength='50' required />
              </div>
              <div class='col-12'>
                <label class='form-label' for='bca_alias'>Alias</label>
                <input type='text' class='form-control' name='bca_alias' id='bca_alias' value='#htmlEditFormat(mCategory.alias())#' maxlength='50' />
                <small>Used when creating SES URLs. If you leave the field blank it will be generated for you.</small>
              </div>
            </div>
            <div class='row mt-3'>
              <div class='col text-center'>
                <button type='submit' name='btnSubmit' id='btnSubmit' class='btn btn-nmg'>Save</button>
                <a href='#router.href('blog/category/list')#' class='btn btn-nmg-cancel'>Cancel</a>
              </div>
            </div>
          </div>
        </div>
      </form>
    </div>
  </div>
</cfoutput>
