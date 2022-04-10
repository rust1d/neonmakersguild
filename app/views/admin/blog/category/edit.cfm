<cfprocessingdirective pageencoding='utf-8'>

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
  <section class='container'>
    <div class='row mb-3'>
      <div class='col'>
        <form role='form' method='post' enctype='multipart/form-data'>
          <div class='card'>
            <h5 class='card-header bg-nmg'>#mode# Category</h5>
            <div class='card-body border-left border-right'>
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
                  <a href='#router.href('blog/category/list')#' class='btn btn-warning'>Cancel</a>
                </div>
              </div>
            </div>
            <div class='card-footer bg-nmg border-top-0'></div>
          </div>
        </form>
      </div>
    </div>
  </section>
</cfoutput>
