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
      url: '/xhr.cfm?p=user/image/pic64',
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
      url: '/xhr.cfm?p=user/image/upload',
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
