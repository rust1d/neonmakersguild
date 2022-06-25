<cfscript>
  tagid = router.decode('tagid');
  mTag = mBlog.tag_find_or_create(tagid);

  if (form.keyExists('btnSubmit')) {
    mTag.set(form);
    if (mBlog.tag_save(mTag)) {
      flash.success('Your tag was saved.');
      router.redirect('blog/tag/list');
    }
  }

  mode = mTag.new_record() ? 'Add' : 'Edit';
</cfscript>

<cfoutput>
  <div class='row mb-3'>
    <div class='col'>
      <form role='form' method='post' enctype='multipart/form-data'>
        <div class='card'>
          <div class='card-header bg-nmg'>
            <div class='row'>
              <div class='col fs-5'>#mode# tag</div>
            </div>
          </div>
          <div class='card-body'>
            <div class='row g-3'>
              <div class='col-12'>
                <label class='form-label required' for='tag_tag'>tag</label>
                <input type='text' class='form-control' name='tag_tag' id='tag_tag' value='#htmlEditFormat(mTag.tag())#' maxlength='50' required />
              </div>
            </div>
            <div class='row mt-3'>
              <div class='col text-center'>
                <button type='submit' name='btnSubmit' id='btnSubmit' class='btn btn-nmg'>Save</button>
                <a href='#router.href('blog/tag/list')#' class='btn btn-nmg-cancel'>Cancel</a>
              </div>
            </div>
          </div>
        </div>
      </form>
    </div>
  </div>
</cfoutput>
