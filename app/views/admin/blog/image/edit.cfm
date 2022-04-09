<!---
  TODO:
  delete image
  edit image
 --->


<cfscript>
  uiid = router.decode('uiid');

  mImage = mBlog.image_find_or_create(uiid);

  if (form.keyExists('btnSubmit')) {
    mImage.set(form);
    if (mImage.safe_save()) {
      flash.success('Your image was saved.');
      router.redirect('blog/image/list');
    } else {
      flash.error('An error occurred while uploading. Please try again or contact us at #session.site.mailto_site()#.');
    }
  }

  mode = mImage.new_record() ? 'Add' : 'Edit';
</cfscript>

<script>
  $(document).ready(() => {
    $('#hidden_input').change(function () {
      const file = this.files[0];
      if (file) {
        img = new Image();
        img.onload = function () {
          let size = file.size / 1024 / 1024;
          $('#file_info').html(`<h4>${file.name}</h4><h6>${size.toFixed(1)} MB</h6><h6>${this.width} x ${this.height}</h6>`);
          URL.revokeObjectURL(this.src);
        };
        img.src =  URL.createObjectURL(file);
        $('#image_preview').attr('src', img.src);
      }
    });
  });
</script>

<cfoutput>
  <section class='container'>
    <div class='row mb-3'>
      <div class='col'>
        <form role='form' method='post' enctype='multipart/form-data'>
          <div class='card'>
            <h5 class='card-header bg-nmg'>#mode# image</h5>
            <div class='card-body border-left border-right'>
              <cfif mode is 'add'>
                <form method='post' enctype='multipart/form-data'>
                  <div class='row'>
                    <div class='col-md-6 col-12'>
                      <div class='row g-3'>
                        <div class='col-12'>
                          Images will be resized to a max height/width of 1200 and a 300x300 thumbnail will be cropped from the center for previews.
                        </div>
                        <div class='col-12 small text-muted'>
                          Once an image has been used in a post it cannot be deleted.
                        </div>
                        <div class='col-12' id='file_info'>
                          filename<br>
                          size<br>
                          dimensions
                        </div>
                        <div class='col-12 small'>
                          <a class='btn btn-nmg mr-3 position-relative'>
                            <span><i class='fal fa-list-radio'></i> Select Photo</span>
                            <input class='h-100 w-100 position-absolute' type='file' id='hidden_input' name='ui_filename' value='Choose a file' accept='image/*'>
                          </a>
                          <button type='submit' name='btnSubmit' id='btnSubmit' class='btn btn-nmg'><i class='fal fa-upload'></i> Save Photo</button>
                          <a href='#router.href('blog/image/list')#' class='btn btn-warning'>Cancel</a>
                        </div>


                      </div>
                    </div>
                    <div class='col-md-6 col-12 text-end'>
                      <img id='image_preview' class='w-100 img-thumbnail' src='/assets/images/profile_placeholder.png' alt='pic' />
                    </div>
                  </div>
                </form>
              <cfelse>
                <div class='row g-3'>
                  <div class='col-md-3 col-12'>
                    <img src='#mImage.thumbnail_src()#' class='w-100 img-thumbnail' />

                    <h4 class='py-3'>#mImage.filename()#</h4>
                    <h6>#mImage.dimensions()# pixels</h6>
                    <h6>#mImage.size_mb()#</h6>
                  </div>
                  <div class='col-md-9 col-12 text-center'>
                    <img src='#mImage.image_src()#' class='w-100 img-thumbnail copy_src' />
                  </div>
                </div>
                <div class='row g-3'>
                  <div class='col-md-3 col-12 text-center'>
                    <hr>
                    <button type='submit' name='btnDelete' id='btnDelete' class='btn btn-danger'>Delete</button>
                    <a href='#router.href('blog/image/list')#' class='btn btn-warning'>Cancel</a>

                  </div>
                  <div class='col-md-9 col-12'>
                    <hr>
                    <div class='text-muted'>
                      <i class='fal fa-copy'></i> <span class='clipable' data-clip='#mImage.image_src()#'>#mImage.image_src()#</span> (#mImage.dimensions()#)
                    </div>
                    <div class='text-muted'>
                      <i class='fal fa-copy'></i> <span class='clipable' data-clip='#mImage.thumbnail_src()#'>#mImage.thumbnail_src()#</span> (thumbnail)
                    </div>
                  </div>
                </div>
              </cfif>
            </div>
            <div class='card-footer bg-nmg border-top-0'></div>
          </div>
        </form>
      </div>
    </div>
  </section>
</cfoutput>
