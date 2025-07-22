$(function() {
  let cropper;
  let originalImage;

  const cropModal = document.getElementById('cropModal');
  const $cropModal = new bootstrap.Modal(cropModal);

  read_image = function() {
    const formData = new FormData();
    formData.append('uiid', $(this).data('uiid'));
    $.post({
      url: '/xhr.cfm?p=user/image/pic64',
      cache: false,
      data: formData,
      dataType: 'json',
      contentType: false,
      processData: false,
      error: function(err) { console.log(err) },
      success: function(data) {
        show_modal(data);
      }
    });
  }

  resetZoom = function() {
    const imageData = cropper.getImageData();
    const minZoom = imageData.width / imageData.naturalWidth;
    cropper.zoomTo(minZoom);
    $('#zoomSlider').val(minZoom);
  }

  setZoom = function() {
    const zoom = cropper.getData().scaleX || 1;
    const imageData = cropper.getImageData();
    const minZoom = imageData.width / imageData.naturalWidth;
    const maxZoom = 3; // arbitrary max, you can calculate if needed
    $('#zoomSlider').attr('min', minZoom).attr('max', maxZoom).val(zoom);
    $('#crop_image').on('zoom.cropper', function(e) { $('#zoomSlider').val(e.detail.ratio) });
  }

  show_modal = function(data) {
    originalImage = data.data;
    $('#thumbnail_crop').html("<img id='crop_image' src='" + originalImage + "' class='img-fluid' />");

    cropModal.addEventListener('shown.bs.modal', function onShown() {
      cropModal.removeEventListener('shown.bs.modal', onShown);
      const image = document.getElementById('crop_image');
      cropper = new Cropper(image, {
        viewMode: 1,
        autoCropArea: 1,
        movable: true,
        zoomable: true,
        scalable: true,
        rotatable: true,
        responsive: true,
        background: false,
        ready: setZoom
      });
    });
    $cropModal.show();
  }

  upload_file = function(blob) {
    const formData = new FormData();
    formData.append('thumbnail', blob, 'crop.jpg');
    formData.append('uiid', $('#btnOpen').data('uiid'));
    $.post({
      url: '/xhr.cfm?p=user/image/upload',
      cache: false,
      data: formData,
      dataType: 'json',
      contentType: false,
      processData: false,
      complete: function() {  },
      error: function(err) { console.error(err) },
      success: function(results) {
        $('#thumbnail_src').attr('src', results.data.src); // cropper.getCroppedCanvas().toDataURL()
        if (results.messages.length) $('#flash-messages').replaceWith(results.messages);
        $cropModal.hide();
      }
    });
  }

  $('#btnRotateLeft').on('click', () => {
    if (cropper) cropper.rotate(-90);
  });

  $('#btnRotateRight').on('click', () => {
    if (cropper) cropper.rotate(90);
  });

  $('#btnAspectGroup button').on('click', function() {
    $('#btnAspectGroup button').removeClass('active');
    $(this).addClass('active');
  });

  $('#btnAspectFree').on('click', function() {
    cropper.setAspectRatio(NaN);
  });

  $('#btnAspectSquare').on('click', function() {
    cropper.setAspectRatio(1);
  });

  $('#btnAspect43').on('click', function() {
    cropper.setAspectRatio(4 / 3);
  });

  $('#btnCrop').on('click', function(ev) {
    cropper.getCroppedCanvas().toBlob(upload_file, 'image/jpeg');
  });

  $('#btnOpen').on('click', read_image);

  $('#hidden_input').change(function () {
    const file = this.files[0];
    if (file) {
      img = new Image();
      img.onload = function () {
        $('input[name=file_rename]').val(file.name);
        $('input[name=ui_mb]').val(`${(file.size / 1024).toFixed(1)} KB`);
        $('input[name=ui_dimensions]').val(`${this.width} x ${this.height}`);
        URL.revokeObjectURL(this.src);
      };
      img.src =  URL.createObjectURL(file);
      $('#image_preview').attr('src', img.src);
    }
  });

  $('#zoomSlider').on('input', function() {
    const zoom = parseFloat(this.value);
    if (cropper) cropper.zoomTo(zoom);
  });
});
