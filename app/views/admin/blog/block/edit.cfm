<cfprocessingdirective pageencoding='utf-8'>
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

<script src='/assets/js/admin/blog/block.js'></script>

<cfoutput>
  <div class='row mb-3'>
    <div class='col'>
      <form role='form' method='post' id='blogform'>
        <div class='card'>
          <div class='card-header btn-nmg'>
            <div class='row'>
              <div class='col fs-5'>#mode# Content Block</div>
            </div>
          </div>
          <div class='card-body'>
            <div class='row mt-3'>
              <div class='col-md-9'>
                <div class='row g-3'>
                  <div class='col-12'>
                    <label class='form-label required' for='btb_label'>Label</label>
                    <input type='text' class='form-control' name='btb_label' id='btb_label' value='#htmlEditFormat(mTextBlock.label())#' maxlength='100' required />
                  </div>
                  <div class='col-12'>
                    <label class='form-label required' for='btb_body'>Body</label>
                    <textarea class='tiny-mce form-control' name='btb_body' id='btb_body'>#htmlEditFormat(mTextBlock.body())#</textarea>
                  </div>
                </div>
              </div>
              <div class='col-md-3'>
                <div class='row g-3'>
                  <div class='col-12'>
                    <label class='form-label required' for='btb_label'>Image Search</label>
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
                <a href='#router.href('blog/block/list')#' class='btn btn-nmg-cancel'>Cancel</a>
              </div>
            </div>
          </div>
        </div>
      </form>
    </div>
  </div>
</cfoutput>
