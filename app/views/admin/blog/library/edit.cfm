<cfscript>
  mBlog = new app.services.user.Blog(1);

  dest = (mBlog.id()==1 && session.site.admin()) ? 'blog' : 'user';
  docid = router.decode('docid');
  mDocument = mBlog.document_find_or_create(docid);

  if (form.keyExists('btnSubmit')) {
    mDocument.set(form);
    if (mDocument.safe_save()) {
      flash.success('Your document was saved.');
      if (form.keyExists('doc_mb')) router.redirenc(page: '#dest#/library/edit', docid: mDocument.docid());

      param form.tagids = '';
      tag_ids = new app.models.Tags().save_tags(mBlog.id(), form.tagids);
      mDocument.DocumentTags(replace: tag_ids.toList());

      param form.doc_categories = '';
      bca_ids = new app.models.BlogCategories().save_categories(mBlog.id(), form.doc_categories);
      mDocument.DocumentCategories(replace: bca_ids.toList());

      router.redirect('#dest#/library/list');
    } else if (form.keyExists('doc_mb')) {
      flash.error('An error occurred while uploading. Please try again or contact #session.site.mailto_site()#.');
      router.redirect('#dest#/library/list');
    }
  } else if (form.keyExists('btnDelete')) {
    mDocument.destroy();
    flash.success('Your document was deleted.');
    router.redirect('#dest#/library/list');
  }

  param form.doc_categories = mDocument.DocumentCategories().map(row => row.dc_bcaid()).toList();
  // qryCats = mBlog.categories();
  mode = mDocument.new_record() ? 'Add' : 'Edit';
</cfscript>

<script>
  $(function() {
    $('#hidden_input').change(function () {
      const file = this.files[0];
      if (file) {
        $('input[name=doc_rename]').val(file.name.replace(/\.[^/.]+$/, ''));
        $('input[name=doc_mb]').val(`${(file.size / 1024).toFixed(1)} KB`);
      }
    });

    select_cat = function() {
      var $cat = $('#bca_category');
      var data = $cat.val().trim();
      $cat.val('');
      if (!data.length) return $cat.focus();
      var matches = $("#doc_categories").find('option').filter((row,obj) => obj.text.localeCompare(data, undefined, { sensitivity: 'accent' })==0);
      if (matches.length) {
        matches[0].selected = true;
        $cat[0].setCustomValidity('');
        return;
      }
      $cat[0].setCustomValidity(`Category ${data} not found.`);
      $cat[0].reportValidity();
      // $("#doc_categories").prepend(`<option value='${data}' selected>${data}</option>`);
    }

    $('#bca_category').on('keydown', function(event) {
      if (event.which==13 || event.which==9) {
        if (event.which==13) event.preventDefault();
        select_cat();
      }
    });

    $('#btnFindCategory').on('click', function() {
      select_cat();
    });
  });
</script>

<cfset include_js('assets/js/tagging.js') />

<cfoutput>
  <form role='form' method='post' enctype='multipart/form-data'>
    <div class='card'>
      <div class='card-header bg-nmg'>
        <div class='row align-items-center'>
          <div class='col fs-5'>#mode# <cfif mode is 'add'>Document<cfelse>#mDocument.filename()#</cfif></div>
          <div class='col-auto'>
            <a class='ms-2 blended-icon' data-bs-toggle='modal' data-bs-target='##helpModal'><i class='fas fa-xl fa-circle-question'></i></a>
          </div>
        </div>
      </div>
      <div class='card-body'>
        <cfif mode is 'add'>
          <form method='post' enctype='multipart/form-data'>
            <div class='row'>
              <div class='col-12 small pb-2'>
                Valid file types are currently:
                <code>pdf</code>, <code>gif</code>, <code>jpeg</code>, <code>png</code>, <code>mpeg</code>, <code>mp4</code>, <code>quicktime</code>, <code>plain text</code>.  Additional types can be added.
              </div>
              <div class='col-md-9 col-12'>
                <div class='row g-3'>
                  <div class='col-12' id='file_info'>
                    <div class='input-group input-group-sm mb-1'>
                      <span class='input-group-text w-6rem btn-nmg required'>Filename</span>
                      <input type='text' class='form-control' name='doc_rename' required maxlength='50' />
                    </div>
                    <div class='input-group input-group-sm mb-1'>
                      <span class='input-group-text w-6rem btn-nmg'>Size</span>
                      <input type='text' class='form-control' name='doc_mb' readonly />
                    </div>
                  </div>
                  <div class='col-12 text-center'>
                    <a class='btn btn-nmg mr-3 position-relative'>
                      <span><i class='fa-solid fa-fw fa-folder-open'></i> Select document</span>
                      <input class='h-100 w-100 position-absolute' type='file' id='hidden_input' name='doc_filename' value='Choose a file' accept='image/*,audio/*,video/*,text/*,application/pdf'>
                    </a>
                    <button type='submit' name='btnSubmit' id='btnSubmit' class='btn btn-nmg'><i class='fa-solid fa-fw fa-upload'></i> Save document</button>
                    <a href='#router.href('#dest#/library/list')#' class='btn btn-nmg-cancel'>Cancel</a>
                  </div>
                </div>
              </div>
            </div>
          </form>
        <cfelse>
          <div class='row'>
            <div class='col-12 col-md-9'>
              <div class='row g-3'>
                <div class='col-12'>
                  <label class='form-label required' for='doc_filename'>Title / Filename</label>
                  <a type='button' name='help_filename' class='ms-2 blended-icon' data-bs-toggle='modal' data-bs-target='##helpModal'><i class='fas fa-circle-question'></i></a>
                  <input type='text' class='form-control' name='doc_filename' id='doc_filename' value='#htmlEditFormat(mDocument.filename())#' maxlength='100' required />
                </div>
                <div class='col-12'>
                  <label class='form-label required' for='doc_description'>Description</label>
                  <a type='button' name='help_description' class='ms-2 blended-icon' data-bs-toggle='modal' data-bs-target='##helpModal'><i class='fas fa-circle-question'></i></a>
                  <textarea class='form-control' maxlength='500' rows='4' name='doc_description' id='doc_description' required>#htmlEditFormat(mDocument.description())#</textarea>
                </div>
                <div class='col-12'>
                  <label class='form-label required' for='tagger'>Tags</label>
                  <a type='button' name='help_tags' class='ms-2 blended-icon' data-bs-toggle='modal' data-bs-target='##helpModal'><i class='fas fa-circle-question'></i></a>
                  <div class='taglist border rounded'>
                    <cfloop array='#mDocument.tags()#' item='mTag'>
                      <span class='badge bg-nmg' data-id='#mTag.tagid()#'><input type=hidden name=tagids value='#mTag.tagid()#' /> #mTag.tag()# <i data-role=remove class='fas fa-times'></i></span>
                    </cfloop>
                    <input type='text' class='form-control' id='tagger' name='tagger' />
                  </div>
                  <small class='text-muted' id='taggerHelp'>Start typing to view existing tags or add a new tag.</small>
                </div>
              </div>
            </div>
            <div class='col-12 col-md-3'>
              <div class='row g-3'>
                <div class='col-12'>
                  <label class='form-label required' for='doc_categories'>Categories</label>
                  <a type='button' name='help_categories' class='ms-2 blended-icon' data-bs-toggle='modal' data-bs-target='##helpModal'><i class='fas fa-circle-question'></i></a>
                  <div class='input-group input-group-sm'>
                    <input type='text' class='form-control' name='bca_category' id='bca_category' maxlength='50' />
                    <button type='button' id='btnFindCategory' class='input-group-text btn-nmg' title='Find Category'><i class='fa fa-search'></i></button>
                  </div>
                  <select class='form-select form-select-sm mt-1' name='doc_categories' id='doc_categories' multiple='multiple' title='ctrl+click to select multiple' size='12'>
                    <cfloop array='#mBlog.categories()#' item='mCat'>
                      <option value='#mCat.bcaid()#' #ifin(listFind(form.doc_categories, mCat.bcaid()), 'selected')#>#mCat.category()#</option>
                    </cfloop>
                  </select>
                </div>
              </div>
            </div>
          </div>
          <div class='row m-5'>
            <div class='col text-center'>
              <button type='submit' name='btnSubmit' id='btnSubmit' class='btn btn-nmg'>Save</button>
              <button type='submit' name='btnDelete' id='btnDelete' class='btn btn-nmg-delete'>Delete</button>
              <a href='#router.href('#dest#/library/list')#' class='btn btn-nmg-cancel'>Cancel</a>
            </div>
          </div>
          <div class='row'>
            <div class='col-2'>
              <label class='form-label'>Type</label>
              <h5>#mDocument.type()#</h5>
            </div>
            <div class='col-2'>
              <label class='form-label'>Size</label>
              <h5>#mDocument.size()#</h5>
            </div>
            <div class='col-2'>
              <label class='form-label'>Views</label>
              <h5>#mDocument.views()#</h5>
            </div>
            <div class='col-2'>
              <label class='form-label'>Downloads</label>
              <h5>#mDocument.downloads()#</h5>
            </div>
            <div class='col-2'>
              <label class='form-label'>DLA</label>
              <h5>#mDocument.dla().format('yyyy-mm-dd')#</h5>
            </div>
            <div class='col-2'>
              <label class='form-label'>Added</label>
              <h5>#mDocument.added().format('yyyy-mm-dd')#</h5>
            </div>
          </div>
          <div class='row g-3'>
            <div class='col-12'>
              <cfif mDocument.type()=='pdf'>
                <embed src='#mDocument.src()#' class='w-100 form-control' style='aspect-ratio: 1' autostart='0' autoplay='false' />
              <cfelse>
                <embed src='#mDocument.src()#' class='w-100 form-control' style='min-height: 500px' autostart='0' autoplay='false' />
              </cfif>
            </div>
          </div>
        </cfif>
      </div>
    </div>
  </form>

  <div class='modal fade' id='helpModal' tabindex='-1' aria-labelledby='helpModalLabel' aria-hidden='true'>
    <div class='modal-dialog border-nmg border rounded modal-lg modal-dialog-scrollable'>
      <div class='modal-content bg-nmg'>
        <div class='modal-header'>
          <h5 class='modal-title' id='helpModalLabel'>Library Document Help</h5>
          <button type='button' class='btn-close' data-bs-dismiss='modal' aria-label='Close'></button>
        </div>
        <div class='modal-body'>
          <div class='container-fluid'>
            #router.include('shared/help/document')#
          </div>
        </div>
      </div>
    </div>
  </div>
</cfoutput>
