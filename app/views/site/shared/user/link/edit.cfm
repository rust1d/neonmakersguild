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
  }

  social_link = mLink.social_link('lg');
  mode = mLink.new_record() ? 'Add' : 'Edit';
</cfscript>

<cfoutput>
  <section class='container'>
    <div class='row mb-3'>
      <div class='col'>
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
                  <cfif social_link.len()>
                    <div class='pt-2 small'>
                      This link will use the #social_link# icon.
                    </div>
                  </cfif>
                </div>
                <div class='col-md-9'>
                  <label class='form-label' for='bli_title'>Title</label>
                  <input type='text' class='form-control' name='bli_title' id='bli_title' value='#htmlEditFormat(mLink.title())#' maxlength='100' />
                </div>
                <div class='col-12'>
                  <label class='form-label required' for='bli_url'>URL</label>
                  <input type='text' class='form-control' name='bli_url' id='bli_url' value='#htmlEditFormat(mLink.url())#' maxlength='200' required />
                </div>
              </div>

              <div class='row mt-3'>
                <div class='col text-center'>
                  <button type='submit' name='btnSubmit' id='btnSubmit' class='btn btn-nmg'>Save</button>
                  <a href='#router.href('#dest#/link/list')#' class='btn btn-warning'>Cancel</a>
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
