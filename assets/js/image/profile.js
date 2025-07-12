$(function () {
  let cropper;
  let originalImage;

  const cropModal = document.getElementById('cropModal');
  const $cropModal = new bootstrap.Modal(cropModal);

  read_image = function(obj, onSuccess) {
    const formData = new FormData();
    formData.append('uiid', $(obj).data('uiid'));
    $.post({
      url: '/xhr.cfm?p=user/image/pic64',
      cache: false,
      data: formData,
      dataType: 'json',
      contentType: false,
      processData: false,
      error: function(err) { console.error(err) },
      success: onSuccess
    });
  }

  delete_image = function() {
    const formData = new FormData();
    formData.set('uiid', $('#image_delete').data('uiid'));
    $.post({
      url: '/xhr.cfm?p=user/image/delete',
      data: formData,
      dataType: 'json',
      contentType: false,
      processData: false,
      error: function(err) { console.error(err) },
      success: function(data) {
        if (data.data.uiid) $(`#img_${data.data.uiid}`).fadeOut();
        $('#image_delete').modal('hide');
        location.reload();
      }
    });
  }

  delete_profile = function() {
    const formData = new FormData();
    formData.set('delete', 1);
    $.post({
      url: '/xhr.cfm?p=user/image/delete',
      data: formData,
      dataType: 'json',
      contentType: false,
      processData: false,
      error: function(err) { console.error(err) },
      success: function(data) {
        $('#profile_image').attr('src', data.data.profile_image);
        $('#profile_modal').modal('hide');
        location.reload();
      }
    });
  }

  setZoom = function() {
    if (!cropper) return;
    cropper.setCropBoxData({ width: 256, height: 256 });
    cropper.setDragMode('none');
    const imageData = cropper.getImageData();
    const minZoom = imageData.width / imageData.naturalWidth;
    $('#zoomSlider')
      .attr('min', minZoom)
      .attr('max', 3)
      .val(cropper.getData().scaleX || minZoom);
  }

  show_modal = function(src) {
    $('#thumbnail_crop').html(`<img id='crop_image' src='${src}' class='img-fluid' />`);

    cropModal.addEventListener('shown.bs.modal', function onShown() {
      cropModal.removeEventListener('shown.bs.modal', onShown);
      const image = document.getElementById('crop_image');
      cropper = new Cropper(image, {
        viewMode: 1,
        autoCropArea: 1,
        aspectRatio: 1,
        movable: true,
        zoomable: true,
        scalable: true,
        rotatable: true,
        responsive: true,
        background: false,
        ready: setZoom
      });
    });
    $('#profile_modal').modal('hide');
    $cropModal.show();
  }

  upload_file = function(blob) {
    const formData = new FormData();
    formData.append('profile_image', blob, 'crop.jpg');
    const input = $('#profile_input')[0];
    if (input?.files?.length) formData.append('ui_filename', input.files[0]);

    $.post({
      url: '/xhr.cfm?p=user/image/upload',
      cache: false,
      data: formData,
      dataType: 'json',
      contentType: false,
      processData: false,
      error: function(err) { console.error(err) },
      success: function(results) {
        if (results?.data?.thumbnail) {
          $('#profile_image').attr('src', results.data.thumbnail);
          $('#image_roll').prepend(`<img src='${results.data.thumbnail}' data-uiid='${results.data.ui_uiid}' />`);
        }
        if (results.messages.length) $('#flash-messages').replaceWith(results.messages);
        $cropModal.hide();
        location.reload();
      }
    });
  }

  $('#btnAspectFree').on('click', function() {
    if (!cropper) return;
    cropper.setAspectRatio(NaN);
    $('#btnAspectGroup .btn').removeClass('active');
    $(this).addClass('active');
  });

  $('#btnAspectSquare').on('click', function() {
    if (!cropper) return;
    cropper.setAspectRatio(1);
    $('#btnAspectGroup .btn').removeClass('active');
    $(this).addClass('active');
  });

  $('#btnAspect43').on('click', function() {
    if (!cropper) return;
    cropper.setAspectRatio(4 / 3);
    $('#btnAspectGroup .btn').removeClass('active');
    $(this).addClass('active');
  });

  $('#btnCrop').on('click', function() {
    if (!cropper) return;
    cropper.getCroppedCanvas({ width: 256, height: 256 }).toBlob(upload_file, 'image/jpeg');
  });

  $('#btnCancel').on('click', function() {
    $cropModal.hide();
  });

  $('#btnRotateLeft').on('click', function() {
    if (!cropper) return;
    // cropper.clear();
    cropper.rotate(-90);
    // cropper.crop();
    // cropper.setAspectRatio(1);
  });

  $('#btnRotateRight').on('click', function() {
    if (!cropper) return;
    cropper.rotate(90);
  });

  $('button[name=btnDelete]').on('click', delete_image);

  $('#image_roll').on('click', 'img', function() {
    read_image(this, function(data) {
      show_modal(data.data);
    });
  });

  $('#image_roll_more').on('click', function() {
    var $imgs = $('#image_roll img').filter(':hidden');
    $imgs.filter(':lt(6)').fadeIn(1000);
    if ($imgs.length < 7) $(this).fadeOut();
  });

  $('#profile_input').on('change', function() {
    const file = this.files[0];
    if (!file) return;

    const reader = new FileReader();
    reader.onload = function(ev) {
      show_modal(ev.target.result);
    }
    reader.readAsDataURL(file);
  });

  $('#profile_remove').on('click', delete_profile);

  $('#zoomSlider').on('input', function() {
    if (!cropper) return;
    const zoom = parseFloat(this.value);
    cropper.zoomTo(zoom);
  });
});
