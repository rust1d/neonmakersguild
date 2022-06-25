<cfscript>
  mBlog = new app.services.user.Blog(1);

  dest = (mBlog.id()==1 && session.site.isA('admin')) ? 'blog' : 'user';
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
  });
</script>

<script src='/assets/js/tagging.js'></script>

<cfoutput>
  <form role='form' method='post' enctype='multipart/form-data'>
    <div class='card'>
      <h5 class='card-header bg-nmg'>
        #mode# <cfif mode is 'add'>document<cfelse>#mDocument.filename()#</cfif>
      </h5>
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
                      <span><i class='fal fa-list-radio'></i> Select document</span>
                      <input class='h-100 w-100 position-absolute' type='file' id='hidden_input' name='doc_filename' value='Choose a file' accept='image/*,audio/*,video/*,text/*,application/pdf'>
                    </a>
                    <button type='submit' name='btnSubmit' id='btnSubmit' class='btn btn-nmg'><i class='fal fa-upload'></i> Save document</button>
                    <a href='#router.href('#dest#/library/list')#' class='btn btn-nmg-cancel'>Cancel</a>
                  </div>
                </div>
              </div>
            </div>
          </form>
        <cfelse>
          <div class='row g-3'>
            <div class='col-md-9 col-12'>
              <label class='form-label required' for='doc_filename'>Filename</label>
              <input type='text' class='form-control' name='doc_filename' id='doc_filename' value='#htmlEditFormat(mDocument.filename())#' maxlength='100' required />
            </div>
            <div class='col-md-3 col-12'>
              <label class='form-label'>Type</label>
              <h5>#mDocument.type()#</h5>
            </div>

            <div class='col-12'>
              <label class='form-label required' for='tagger'>Tags</label>
              <div class='taglist border rounded'>
                <cfloop array='#mDocument.tags()#' item='mTag'>
                  <span class='badge bg-nmg' data-id='#mTag.tagid()#'><input type=hidden name=tagids value='#mTag.tagid()#' /> #mTag.tag()# <i data-role=remove class='fas fa-times'></i></span>
                </cfloop>
                <input type='text' class='form-control' id='tagger' name='tagger' />
              </div>
              <small class='form-text text-muted' id='taggerHelp'>Start typing to view existing tags or add a new tag.</small>
            </div>

            <div class='col-12'>
              <label class='form-label required' for='doc_description'>Description</label>
              <textarea class='form-control' maxlength='500' rows='3' name='doc_description' id='doc_description'>#htmlEditFormat(mDocument.description())#</textarea>
            </div>
            <div class='col-3'>
              <label class='form-label'>Size</label>
              <h5>#mDocument.size()#</h5>
            </div>
            <div class='col-3'>
              <label class='form-label'>Clicks</label>
              <h5>#mDocument.clicks()#</h5>
            </div>
            <div class='col-3'>
              <label class='form-label'>DLA</label>
              <h5>#mDocument.dla().format('yyyy-mm-dd')#</h5>
            </div>
            <div class='col-3'>
              <label class='form-label'>Added</label>
              <h5>#mDocument.added().format('yyyy-mm-dd')#</h5>
            </div>
          </div>
          <div class='row m-5'>
            <div class='col text-center'>
              <button type='submit' name='btnSubmit' id='btnSubmit' class='btn btn-nmg'>Save</button>
              <button type='submit' name='btnDelete' id='btnDelete' class='btn btn-nmg-delete'>Delete</button>
              <a href='#router.href('#dest#/library/list')#' class='btn btn-nmg-cancel'>Cancel</a>
            </div>
          </div>
          <div class='row g-3'>
            <div class='col-12'>
              <label class='form-label'>Preview</label>
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
</cfoutput>
