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
      router.redirenc('#dest#/image/edit');
    }
  } else if (form.keyExists('btnDelete')) {
    mImage.destroy();
    flash.success('Your image was deleted.');
    router.redirect('#dest#/image/list');
  }

  mode = mImage.new_record() ? 'Add' : 'Edit';
</cfscript>

<cfset include_js('assets/js/image/edit.js') />

<cfoutput>
  #router.include('shared/user/image/_crop_modal')#

  <form role='form' method='post' enctype='multipart/form-data'>
    <div class='card'>
      <h5 class='card-header bg-nmg align-items-center'>
        #mode#
        <cfif mode is 'add'>
          Image
        <cfelse>
          #mImage.filename()#
        </cfif>
      </h5>
      <div class='card-body'>
        <cfif mode is 'add'>
          <form method='post' enctype='multipart/form-data'>
            <div class='row'>
              <div class='col-md-6 col-12'>
                <div class='row g-3'>
                  <div class='col-12'>
                    Images will be resized to a max height/width of #mImage.size_image()#px and a thumbnail will be created for previews.
                  </div>
                  <div class='col-12' id='file_info'>
                    <div class='input-group input-group-sm mb-1'>
                      <span class='input-group-text w-25 btn-nmg required'>Name</span>
                      <input type='text' class='form-control' name='file_rename' required maxlength='100' />
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
                    <a class='btn btn-nmg btn-wide mr-3 position-relative'>
                      <span><i class='fa-solid fa-fw fa-camera'></i> Select Image</span>
                      <input class='h-100 w-100 position-absolute' type='file' id='hidden_input' name='ui_filename' value='Choose a file' accept='image/*'>
                    </a>
                    <button type='submit' name='btnSubmit' id='btnSubmit' class='btn btn-wide btn-nmg'><i class='fa-solid fa-fw fa-upload'></i> Save Image</button>
                    <a href='#router.href('#dest#/image/list')#' class='btn btn-wide btn-nmg-cancel'>Cancel</a>
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
            <div class='col-md-auto'>
              <div class='position-relative d-inline-block'>
                <img id='thumbnail_src' src='#mImage.thumbnail_src()#' class='img-thumbnail' />
                <button type='button' id='btnOpen' data-uiid='#mImage.encoded_key()#' title='change thumbnail' class='btn btn-icon bottom-right btn-nmg btn-outline-dark'>
                  <i class='fa-solid fa-photo-film'></i>
                </button>
              </div>
              <div class='bg-nmg mt-3 fs-6'>
                <div class='border-bottom py-1 px-2'>
                  #mImage.dimensions()#
                </div>
                <div class='border-bottom py-1 px-2'>
                  #mImage.size_mb()#
                </div>
                <div class='border-bottom py-1 px-2'>
                  <span class='clipable' data-clip='#mImage.image_src()#'>
                    <i class='fa-solid fa-fw fa-copy'></i> Image Link (#mImage.dimensions()#)
                  </span>
                </div>
                <div class='py-1 px-2'>
                  <span class='clipable' data-clip='#mImage.thumbnail_src()#'>
                    <i class='fa-solid fa-fw fa-copy'></i>  Thumbnail Link
                  </span>
                </div>
              </div>
              <div class='mt-3'>
                <label class='form-label form-text' for='ui_filename'>Rename</label>
                <div class='input-group input-group-sm'>
                  <input type='text' class='form-control' name='ui_filename' value='#mImage.filename()#' />
                  <button type='submit' name='btnSubmit' class='btn btn-sm btn-nmg'>go</button>
                </div>
              </div>
              <div class='mt-3 text-center'>
                <hr>
                <a href='#router.href('#dest#/image/list')#' class='btn btn-wide btn-nmg'>Done</a>
              </div>
            </div>
            <div class='col-md'>
              <div class='position-relative d-inline-block'>
                <img src='#mImage.image_src()#' class='img-thumbnail img-fluid clipable' data-clip='#mImage.image_src()#' />
                <button type='submit' name='btnDelete' id='btnDelete' class='btn btn-icon bottom-right btn-nmg btn-outline-dark'>
                  <i class='fa-solid fa-trash'></i>
                </button>
              </div>
            </div>
          </div>
        </cfif>
      </div>
    </div>
  </form>
</cfoutput>
