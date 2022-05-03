<cfscript>
  dest = (mBlog.id()==1 && session.site.isA('admin')) ? 'blog' : 'user';
  bliid = router.decode('bliid');
  mLink = mBlog.link_find_or_create(bliid);

  if (form.keyExists('btnSubmit')) {
    mLink.set(form);
    if (mLink.safe_save()) {
      flash.success('Your link was saved.');
      router.redirect('#dest#/link/list');
    }
  } else if (form.keyExists('btnDelete')) {
    mLink.destroy();
    flash.success('Your link was deleted.');
    router.redirect('#dest#/link/list');
  }

  icon_link = mLink.icon_link('lg');
  mode = mLink.new_record() ? 'Add' : 'Edit';
</cfscript>

<cfoutput>
  <form role='form' method='post' enctype='multipart/form-data'>
    <div class='card'>
      <h5 class='card-header bg-nmg'>#mode# Link</h5>
      <div class='card-body'>
        <div class='row g-3'>
          <div class='col-md-3'>
            <label class='form-label' for='bli_type'>Type</label>
            <select class='form-control' name='bli_type' id='bli_type'>
              <cfloop array='#mLink.types()#' item='type'>
                <option value='#type#' #ifin(mLink.type()==type, 'selected')#>#type#</option>
              </cfloop>
            </select>
            <cfif icon_link.len()>
              <small class='pt-2'>
                This link will use the #icon_link# icon.
              </small>
            </cfif>
          </div>
          <div class='col-12'>
            <label class='form-label required' for='bli_url'>URL</label>
            <div class='input-group mb-3'>
              <input type='text' class='form-control' name='bli_url' id='bli_url' value='#htmlEditFormat(mLink.url())#' maxlength='200' required />
              <button class='btn btn-nmg' title='test url' type='button' onclick='window.open(this.form.bli_url.value); return false;'><i class='fa-regular fa-up-right-from-square'></i></button>
            </div>
          </div>
          <div class='col-12'>
            <label class='form-label required' for='bli_title'>Title</label>
            <input type='text' class='form-control' name='bli_title' id='bli_title' value='#htmlEditFormat(mLink.title())#' maxlength='100' required />
          </div>
          <div class='col-12'>
            <label class='form-label' for='bli_description'>Description</label>
            <input type='text' class='form-control' name='bli_description' id='bli_description' value='#htmlEditFormat(mLink.description())#' maxlength='200' />
            <small>Only displayed for "resource" links but used for searching all types.</small>
          </div>
        </div>
        <div class='row mt-3'>
          <div class='col text-center'>
            <button type='submit' name='btnSubmit' id='btnSubmit' class='btn btn-nmg'>Save</button>
            <cfif mLink.persisted()><button type='submit' name='btnDelete' id='btnDelete' class='btn btn-nmg-delete'>Delete</button></cfif>
            <a href='#router.href('#dest#/link/list')#' class='btn btn-nmg-cancel'>Cancel</a>
          </div>
        </div>
      </div>
    </div>
  </form>
</cfoutput>
