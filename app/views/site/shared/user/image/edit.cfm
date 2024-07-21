<cfscript>
  dest = (mBlog.id()==1 && session.site.admin()) ? 'blog' : 'user';
  uiid = router.decode('uiid');
  mImage = mBlog.image_find_or_create(uiid);

  if (form.keyExists('btnSubmit')) {
    mImage.set(form);
    if (mImage.safe_save()) {
      flash.success('Your image was saved.');
      router.redirect('#dest#/image/list');
    } else {
      flash.error('An error occurred while uploading. Please try again or contact #session.site.mailto_site()#.');
    }
  } else if (form.keyExists('btnDelete')) {
    mImage.destroy();
    flash.success('Your image was deleted.');
    router.redirect('#dest#/image/list');
  }

  mode = mImage.new_record() ? 'Add' : 'Edit';
</cfscript>

<script src='/assets/js/image/edit.js'></script>

<cfoutput>
  <form role='form' method='post' enctype='multipart/form-data'>
    <div class='card'>
      <h5 class='card-header bg-nmg'>
        #mode# <cfif mode is 'add'>image<cfelse>#mImage.filename()#</cfif>
      </h5>
      <div class='card-body'>
        <cfif mode is 'add'>
          <form method='post' enctype='multipart/form-data'>
            <div class='row'>
              <div class='col-md-6 col-12'>
                <div class='row g-3'>
                  <div class='col-12'>
                    Images will be resized to a max height/width of 1200 and a 300x300 thumbnail will be cropped from the center for previews.
                  </div>
                  <div class='col-12' id='file_info'>
                    <div class='input-group input-group-sm mb-1'>
                      <span class='input-group-text w-25 btn-nmg required'>Name</span>
                      <input type='text' class='form-control' name='ui_rename' required maxlength='100' />
                    </div>
                    <div class='input-group input-group-sm mb-1'>
                      <span class='input-group-text w-25 btn-nmg'>Bytes</span>
                      <input type='text' class='form-control' name='ui_mb' readonly />
                    </div>
                    <div class='input-group input-group-sm mb-1'>
                      <span class='input-group-text w-25 btn-nmg'>Size</span>
                      <input type='text' class='form-control' name='ui_dimensions' readonly />
                    </div>
                  </div>
                  <div class='col-12 text-center'>
                    <a class='btn btn-nmg mr-3 position-relative'>
                      <span><i class='fa-solid fa-fw fa-list-radio'></i> Select Image</span>
                      <input class='h-100 w-100 position-absolute' type='file' id='hidden_input' name='ui_filename' value='Choose a file' accept='image/*'>
                    </a>
                    <button type='submit' name='btnSubmit' id='btnSubmit' class='btn btn-nmg'><i class='fa-solid fa-fw fa-upload'></i> Save Image</button>
                    <a href='#router.href('#dest#/image/list')#' class='btn btn-nmg-cancel'>Cancel</a>
                  </div>
                </div>
              </div>
              <div class='col-md-6 col-12 text-end'>
                <img id='image_preview' class='w-100 img-thumbnail' src='#application.urls.cdn#/assets/images/profile_placeholder.png' alt='pic' />
              </div>
            </div>
          </form>
        <cfelse>
          <div class='row g-3'>
            <div class='col-auto'>
              <div id='thumbnail_view'>
                <div class='position-relative'>
                  <img id='thumbnail_src' src='#mImage.thumbnail_src()#' class='profile-crop-wrapper img-thumbnail' />
                  <button type='button' id='btnOpen' data-uiid='#mImage.encoded_key()#' title='change thumbnail' class='image-crop-btn rounded-circle btn btn-nmg btn-outline-dark fa-thin fa-photo-film'></button>
                </div>
                <div class='input-group input-group-sm mt-1'>
                  <input type='text' class='form-control' name='ui_filename' value='#mImage.filename()#' />
                  <button type='submit' name='btnSubmit' class='btn btn-sm btn-nmg'>rename</button>
                </div>
              </div>
              <div class='image-crop-wrapper d-none'>
                <div id='thumbnail_crop' class='profile-crop-wrapper img-thumbnail'></div>
                <div class='text-center my-3'>
                  <button type='button' class='btn btn-sm btn-nmg' id='btnCrop'>Save thumbnail</button>
                  <button type='button' class='btn btn-sm btn-nmg' id='btnCancel'>Cancel</button>
                </div>
                <br clear='all'>
              </div>
            </div>
            <div class='col-md'>
              <img src='#mImage.image_src()#' class='w-100 img-thumbnail clipable' data-clip='#mImage.image_src()#' />
            </div>
          </div>

          <div class='row g-3'>
            <div class='col-md-3 col-12 text-center'>
              <hr>
              <button type='submit' name='btnDelete' id='btnDelete' class='btn btn-nmg-delete'>Delete</button>
              <a href='#router.href('#dest#/image/list')#' class='btn btn-nmg-cancel'>Cancel</a>
            </div>
            <div class='col-md-8 col-12'>
              <hr>
              <div class='text-muted small'>
                <i class='fa-solid fa-fw fa-copy'></i> <span class='clipable' data-clip='#mImage.image_src()#'>#mImage.image_src()#</span> (#mImage.dimensions()#)
              </div>
              <div class='text-muted small'>
                <i class='fa-solid fa-fw fa-copy'></i> <span class='clipable' data-clip='#mImage.thumbnail_src()#'>#mImage.thumbnail_src()#</span> (thumbnail)
              </div>
            </div>

            <cfif mImage.uses().len()>
              <div class='col-12 text-danger small mt-3 border border-danger p-3'>
                <p>This image is used in posted content. Deleting the image now will only remove it from the library.
                A copy of the image remain in the tubes to support the posted content. To completely delete an image
                from the server, remove it from all posted content first.</p>
                Used in: #mImage.uses().map(row => '#row.src_table#: #row.src_pkid#').toList(', ')#
              </div>
            </cfif>
          </div>
        </cfif>
      </div>
    </div>
  </form>
</cfoutput>
