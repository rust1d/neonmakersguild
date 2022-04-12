<cfscript>
  uiid = router.decode('uiid');
  mImage = mBlog.image_find_or_create(uiid);

  if (form.keyExists('btnSubmit')) {
    mImage.set(form);
    if (mImage.safe_save()) {
      flash.success('Your image was saved.');
      router.redirect('user/image/list');
    } else {
      flash.error('An error occurred while uploading. Please try again or contact #session.site.mailto_site()#.');
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
          $('input[name=ui_rename]').val(file.name);
          $('input[name=ui_mb]').val(`${(file.size / 1024).toFixed(1)} KB`);
          $('input[name=ui_dimensions]').val(`${this.width} x ${this.height}`);
          URL.revokeObjectURL(this.src);
        };
        img.src =  URL.createObjectURL(file);
        $('#image_preview').attr('src', img.src);
      }
    });

    var $nailer = $('#thumbnail_crop').croppie({
      viewport: { width: 290, height: 290, type: 'square' },
      enableExif: true
    });

    read_image = function() {
      const formData = new FormData();
      formData.append('uiid', $(this).data('uiid'));
      $.post({
        url: 'xhr.cfm?p=user/image/pic64',
        cache: false,
        data: formData,
        dataType: 'json',
        contentType: false,
        processData: false,
        error: function(err) { console.log(err) },
        success: function(data) {
          show_cropper();
          $nailer.croppie('bind', { url: data.data });
        }
      });
    }

    show_cropper = function() {
      $('#thumbnail_view').addClass('d-none');
      $('.image-crop-wrapper').removeClass('d-none');
    }

    hide_cropper = function() {
      $('#thumbnail_view').removeClass('d-none');
      $('.image-crop-wrapper').addClass('d-none');
    }

    upload_file = function(resp) {
      const formData = new FormData();
      formData.append('thumbnail', uri_to_blob(resp), 'crop.jpg');
      formData.append('uiid', $('#btnOpen').data('uiid'));
      $.post({
        url: 'xhr.cfm?p=user/image/upload',
        cache: false,
        data: formData,
        dataType: 'json',
        contentType: false,
        processData: false,
        complete: function() {  },
        error: function(err) { console.error(err) },
        success: function(results) {
          $('#thumbnail_src').attr('src', resp);
          if (results.messages.length) $('#flash-messages').replaceWith(results.messages);
          hide_cropper();
          // location.reload();
        }
      });
    }

    $('#btnCrop').on('click', function(ev) {
      $nailer.croppie('result', { type: 'canvas', size: 'viewport' }).then(upload_file);
    });

    $('#btnCancel').on('click', hide_cropper);
    $('#btnOpen').on('click', read_image);
  });
</script>

<cfoutput>
  <section class='container'>
    <form role='form' method='post' enctype='multipart/form-data'>
      <div class='card'>
        <h5 class='card-header bg-nmg'>
          #mode# <cfif mode is 'add'>image<cfelse>#mImage.filename()#</cfif>
        </h5>
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
                      Once an image has been used on the site it cannot be deleted.
                    </div>
                    <div class='col-8' id='file_info'>
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
                    <div class='col-8 text-center'>
                      <a class='btn btn-nmg mr-3 position-relative'>
                        <span><i class='fal fa-list-radio'></i> Select Image</span>
                        <input class='h-100 w-100 position-absolute' type='file' id='hidden_input' name='ui_filename' value='Choose a file' accept='image/*'>
                      </a>
                      <button type='submit' name='btnSubmit' id='btnSubmit' class='btn btn-nmg'><i class='fal fa-upload'></i> Save Image</button>
                      <a href='#router.href('user/image/list')#' class='btn btn-warning'>Cancel</a>
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
              <div class='col-md-3 col-12 text-center position-relative'>
                <div id='thumbnail_view'>
                  <div class='position-relative'>
                    <img id='thumbnail_src' src='#mImage.thumbnail_src()#' class='w-100 img-thumbnail' />
                    <button type='button' id='btnOpen' data-uiid='#mImage.encoded_key()#' title='change thumbnail' class='image-crop-btn rounded-circle btn btn-nmg btn-outline-dark fa-thin fa-photo-film'></button>
                  </div>
                  <div class='input-group input-group-sm mb-1 position-absolute bottom-0 start-0'>
                    <input type='text' class='form-control' name='ui_filename' value='#mImage.filename()#' />
                    <button type='submit' name='btnSubmit' class='btn btn-nmg btn-sm btn-outline-dark'>rename</button>
                  </div>
                </div>
                <div class='image-crop-wrapper d-none'>
                  <div id='thumbnail_crop' class='mb-5'></div>
                  <div class='text-center'>
                    <button type='button' class='btn btn-sm btn-nmg' id='btnCrop'>Save thumbnail</button>
                    <button type='button' class='btn btn-sm btn-nmg' id='btnCancel'>Cancel</button>
                  </div>
                </div>


              </div>
              <div class='col-md-9 col-12 text-center'>
                <img src='#mImage.image_src()#' class='w-100 img-thumbnail clipable' data-clip='#mImage.image_src()#' />
                <!--- <small class='fst-italic muted'>#mImage.dimensions()# pixels &bull; #mImage.size_mb()#</small> --->
              </div>
            </div>
            <div class='row g-3'>
              <div class='col-md-3 col-12 text-center'>
                <hr>
                <button type='submit' name='btnDelete' id='btnDelete' class='btn btn-danger'>Delete</button>
                <a href='#router.href('user/image/list')#' class='btn btn-warning'>Cancel</a>
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
        <div class='card-footer bg-nmg border-top-0 text-end small'>#mBlog.name()#</div>
      </div>
    </form>
  </section>
</cfoutput>
