
<cfscript>
  mTextBlock = mBlog.textblock_find_or_create(router.decode('btbid'));

  if (form.keyExists('btnSubmit')) {
    mTextBlock.set(form);
    if (mTextBlock.safe_save()) {
      flash.success('Your content block was saved.');
      router.redirect('blog/block/list');
    }
  }

  mode = mTextBlock.new_record() ? 'Add' : 'Edit';
</cfscript>

<cfset include_js('assets/js/admin/blog/block.js') />
<cfset include_js('assets/js/image/select.js') />

<cfoutput>
  <div class='row mb-3'>
    <div class='col'>
      <form role='form' method='post' id='blogform'>
        <div class='card'>
          <div class='card-header bg-nmg'>
            <div class='row'>
              <div class='col fs-5'>#mode# Content Block</div>
            </div>
          </div>
          <div class='card-body'>
            <div class='row g-3'>
              <div class='col-12'>
                <label class='form-label required' for='btb_label'>Label</label>
                <input type='text' class='form-control' name='btb_label' id='btb_label' value='#htmlEditFormat(mTextBlock.label())#' maxlength='100' required />
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
                <label class='form-label required' for='btb_body'>Body</label>
                <textarea class='tiny-mce form-control' rows='15' name='btb_body' id='btb_body'>#htmlEditFormat(mTextBlock.body_cdn())#</textarea>
              </div>
            </div>
            <div class='row mt-5'>
              <div class='col text-center'>
                <button type='submit' name='btnSubmit' id='btnSubmit' class='btn btn-nmg'>Save</button>
                <button type='button' name='btnPreview' id='btnPreview' class='btn btn-nmg'>Preview</button>
                <a href='#router.href('blog/block/list')#' class='btn btn-nmg-cancel'>Cancel</a>
              </div>
            </div>
          </div>
        </div>
      </form>
    </div>
  </div>
</cfoutput>
