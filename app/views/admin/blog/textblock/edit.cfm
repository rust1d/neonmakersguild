<cfprocessingdirective pageencoding='utf-8'>
<cfscript>
  mTextBlock = mBlog.textblock_find_or_create(router.decode('btbid'));

  if (form.keyExists('btnSubmit')) {

    mTextBlock.set(form);
    if (mTextBlock.safe_save()) {
      flash.success('Your textblock was saved.');
      router.redirect('blog/textblock/list');
    }
  }

  mode = mTextBlock.new_record() ? 'Add' : 'Edit';
</cfscript>

<script src='/assets/js/admin/blog/textblock.js'></script>

<cfoutput>
  <section class='container'>
    <div class='row mb-3'>
      <div class='col'>
        <form role='form' method='post' id='blogform'>
          <div class='card'>
            <h5 class='card-header bg-nmg'>#mode# TextBlock</h5>
            <div class='card-body border-left border-right'>
              <div class='row mt-3'>
                <div class='col-md-8'>
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
                <div class='col-md-4'>
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
                        <div class='col p-1'><img width='128' src='/assets/images/profile_placeholder.png' /></div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
              <div class='row mt-3'>
                <hr>
                <div class='col text-center'>
                  <button type='submit' name='btnSubmit' id='btnSubmit' class='btn btn-nmg'>Save</button>
                  <button type='button' name='btnPreview' id='btnPreview' class='btn btn-nmg'>Preview</button>
                  <a href='#router.href('blog/textblock/list')#' class='btn btn-warning'>Cancel</a>
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
