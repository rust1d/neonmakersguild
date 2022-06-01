<cfscript>
  foid = router.decode('foid');
  mForum = new app.models.Forums();
  if (foid) mForum = mForum.find(foid);

  if (form.keyExists('btnSubmit')) {
    mForum.set(form);
    if (mForum.safe_save()) {
      flash.success('Forum data saved.')
      router.redirect('forum/list');
    }
  }

  mode = mForum.new_record() ? 'Add' : 'Edit';
</cfscript>

<cfoutput>
  <div class='row justify-content-center'>
    <div class='col'>
      <form method='post'>
        <div class='card'>
          <div class='card-header bg-nmg'>
            <div class='row'>
              <div class='col fs-5'>#mode# Forum</div>
            </div>
          </div>
          <div class='card-body'>
            <div class='row g-3'>
              <div class='col-12'>
                <label class='form-label #ifin(mForum.new_record(), 'required')#' for='fo_name'>Forum Name</label>
                <input type='text' class='form-control' name='fo_name' id='fo_name' value='#encodeForHTML(mForum.name())#' maxlength='50' #ifin(mForum.new_record(), 'required', 'readonly')# />
              </div>
              <div class='col-8'>
                <label class='form-label' for='fo_alias'>SEO Alias</label> <small class='text-muted ps-3'>auto-generated from title if left blank</small>
                <input type='text' class='form-control' name='fo_alias' id='fo_alias' value='#mForum.alias()#' maxlength='50' />
              </div>
              <div class='col-2'>
                <label class='form-label mb-0' for='fo_active'>Active</label>
                <div class='form-check form-switch form-control-lg'>
                  <input class='form-check-input mb-2' type='checkbox' id='fo_active' name='fo_active' value='yes' #ifin(mForum.active(), 'checked')# />
                </div>
              </div>
              <div class='col-2'>
                <label class='form-label mb-0' for='fo_admin'>Admin Only</label>
                <div class='form-check form-switch form-control-lg'>
                  <input class='form-check-input mb-2' type='checkbox' id='fo_admin' name='fo_admin' value='yes' #ifin(mForum.admin(), 'checked')# />
                </div>
              </div>
              <div class='col-12'>
                <label class='form-label' for='fo_description'>Description</label>
                <input type='text' class='form-control' name='fo_description' id='fo_description' value='#encodeForHTML(mForum.description())#' maxlength='255' />
              </div>
              <div class='col-3'>
                <label class='form-label' for='fo_order'>Sort Order</label>
                <input type='text' class='form-control' id='fo_order' name='fo_order' value='#mForum.order()#' />
              </div>
              <div class='col-3'>
                <label class='form-label' for='fo_threads'>Threads</label>
                <input type='text' class='form-control' id='fo_threads' name='fo_threads' value='#mForum.threads()#' readonly />
              </div>
              <div class='col-3'>
                <label class='form-label' for='fo_messages'>Messages</label>
                <input type='text' class='form-control' id='fo_messages' name='fo_messages' value='#mForum.messages()#' readonly />
              </div>
              <div class='col-3'>
                <label class='form-label' for='fo_last_fmid'>Last Message Id</label>
                <input type='text' class='form-control' id='fo_last_fmid' name='fo_last_fmid' value='#mForum.last_fmid()#' readonly />
              </div>
            </div>
            <div class='row mt-5'>
              <div class='col text-center'>
                <button type='submit' name='btnSubmit' id='btnSubmit' class='btn btn-nmg'>Save</button>
                <a href='#router.href('forum/list')#' class='btn btn-nmg-cancel'>Cancel</a>
              </div>
            </div>
          </div>
        </div>
      </form>
    </div>
  </div>
</cfoutput>