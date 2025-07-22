<cfscript>
  locals.dest = (locals.mBlog.id()==1 && session.site.admin()) ? 'blog' : 'user';
  locals.mLink = locals.mBlog.link_find_or_create(router.decode('bliid'));

  if (form.keyExists('btnSubmit')) {
    locals.mLink.set(form);
    if (locals.mLink.safe_save()) {
      flash.success('Your link was saved.');
      router.redirect('#locals.dest#/link/list');
    }
  } else if (form.keyExists('btnDelete')) {
    locals.mLink.destroy();
    flash.success('Your link was deleted.');
    router.redirect('#locals.dest#/link/list');
  }

  icon_link = locals.mLink.icon_link('lg');
  mode = locals.mLink.new_record() ? 'Add' : 'Edit';
</cfscript>

<cfset include_js('assets/js/link/edit.js') />

<cfoutput>
  <script data-json='icons' type='application/json'>
    #SerializeJson(locals.mLink.icons())#
  </script>
  <script data-json='socials' type='application/json'>
    #SerializeJson(locals.mLink.social_domains())#
  </script>

  <form role='form' method='post' enctype='multipart/form-data'>
    <div class='card'>
      <h5 class='card-header bg-nmg'>#mode# Link</h5>
      <div class='card-body'>
        <div class='row g-3'>
          <div class='col-12'>
            <label class='form-label required' for='bli_url'>URL</label>
            <div class='input-group mb-3'>
              <input type='text' class='form-control' name='bli_url' id='bli_url' value='#htmlEditFormat(locals.mLink.url())#' maxlength='200' required />
              <button class='btn btn-nmg' title='test url' type='button' onclick='window.open(this.form.bli_url.value); return false;'><i class='fa-solid fa-up-right-from-square'></i></button>
            </div>
          </div>
          <div class='col-md-3'>
            <label class='form-label' for='bli_type'>Link Type</label>
            <select class='form-select' name='bli_type' id='bli_type'>
              <cfloop array='#locals.mLink.types()#' item='type'>
                <option value='#type#' #ifin(locals.mLink.type()==type, 'selected')#>#type#</option>
              </cfloop>
            </select>
          </div>
          <div class='col-auto'>
            <label class='form-label'>Icon</label>
            <span id='link_icon'>#locals.mLink.icon('roundy mt-0 lg')#</span>
          </div>
          <div class='col-12'>
            <label class='form-label required' for='bli_title'>Title</label>
            <input type='text' class='form-control' name='bli_title' id='bli_title' value='#htmlEditFormat(locals.mLink.title())#' maxlength='100' required />
          </div>
          <div class='col-12'>
            <label class='form-label' for='bli_description'>Description</label>
            <input type='text' class='form-control' name='bli_description' id='bli_description' value='#htmlEditFormat(locals.mLink.description())#' maxlength='200' />
            <div class='form-text smaller mt-1'>Only displayed for "resource" links but used for searching links.</div>
          </div>
        </div>
        <div class='row mt-3'>
          <div class='col text-center'>
            <button type='submit' name='btnSubmit' id='btnSubmit' class='btn btn-nmg'>Save</button>
            <cfif locals.mLink.persisted()><button type='submit' name='btnDelete' id='btnDelete' class='btn btn-nmg-delete'>Delete</button></cfif>
            <a href='#router.href('#locals.dest#/link/list')#' class='btn btn-nmg-cancel'>Cancel</a>
          </div>
        </div>
      </div>
    </div>
  </form>
</cfoutput>
