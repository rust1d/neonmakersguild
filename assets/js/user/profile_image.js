$(function () {
  var $uploader = $('#upload_profile').croppie({
    viewport: { width: 290, height: 290, type: 'square' },
    enableExif: true
  });

  delete_image = function() {
    const formData = new FormData();
    formData.set('uiid', $('#image_delete').data('uiid'));
    $.post({
      url: 'xhr.cfm?p=user/images/delete',
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
      url: 'xhr.cfm?p=user/images/delete',
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

  show_picker = function() {
    $('.image-picker').toggleClass('d-none', false);
    $('.image-cropper').toggleClass('d-none', true);
    $('#modal_buttons').toggleClass('d-none', true);
  }

  show_cropper = function() {
    $('.image-picker').toggleClass('d-none', true);
    $('.image-cropper').toggleClass('d-none', false);
    $('#modal_buttons').toggleClass('d-none', false);
  }

  read_image = function(obj, onSuccess) {
    const formData = new FormData();
    formData.append('uiid', $(obj).data('uiid'));
    $.post({
      url: 'xhr.cfm?p=user/images/pic64',
      cache: false,
      data: formData,
      dataType: 'json',
      contentType: false,
      processData: false,
      error: function(err) { console.log(err) },
      success: onSuccess
    });
  }

  read_file = function(input) {
    if (input.files && input.files[0]) {
      var reader = new FileReader();
      reader.onload = function(ev) {
        show_cropper();
        $uploader.croppie('bind', { url: ev.target.result });
      }
      reader.readAsDataURL(input.files[0]);
    } else {
      alert('Your browser does not support the HTML5 FileReader API');
    }
  }

  refresh_cropper = function() {
    $uploader.croppie('refresh');
  }

  upload_file = function(resp) {
    var input = $('#profile_input')[0] || { files: [] };
    const formData = new FormData();
    formData.append('profile_image', uri_to_blob(resp), 'crop.jpg');
    if (input.files.length) formData.append('ui_filename', input.files[0]);
    $.post({
      url: 'xhr.cfm?p=user/images/upload',
      cache: false,
      data: formData,
      dataType: 'json',
      contentType: false,
      processData: false,
      complete: function() {  },
      error: function(err) { console.error(err) },
      success: function(results) {
        if (input.files.length) {
          input.value = null; // CLEAR FILE
          $('#image_roll').prepend(`<img src='${results.data.thumbnail}' data-uiid='${results.data.ui_uiid}' />`);
        }
        $('#profile_image').attr('src', resp);
        if (results.messages.length) $('#flash-messages').replaceWith(results.messages);
        $('#profile_modal').modal('hide');
        location.reload();
      }
    });
  }

  uri_to_blob = function(uri) {
    const parts = uri.split(',');
    const mime = parts[0].split(':')[1].split(';')[0];
    const binary = atob(parts[1]);
    var data = [];
    for (var i=0; i<binary.length; i++) data.push(binary.charCodeAt(i));
    return new Blob([new Uint8Array(data)], { type: mime });
  }

  $('#profile_input').on('change', function() { read_file(this) });

  // $('#image_roll').on('click', 'img', function() {
  //   read_image(this, function(data) {
  //     show_cropper();
  //     $uploader.croppie('bind', { url: data.data });
  //   });
  // });

  $('#profile_modal').on('hidden.bs.modal', show_picker);
  $('#profile_modal').on('shown.bs.modal', refresh_cropper);
  $('#btnCancel').on('click', show_picker);

  $('#btnSave').on('click', function(ev) {
    $uploader.croppie('result', { type: 'canvas', size: 'viewport' }).then(upload_file);
  });

  $('#image_roll_more').on('click', function() {
    var $imgs = $('#image_roll img').filter(':hidden');
    $imgs.filter(':lt(6)').fadeIn(1000);
    if ($imgs.length < 7) $(this).fadeOut();
  });

  $('.image-menu-btn').on('click', function(e) {
    var uiid = $(this).closest('span').data('uiid');
    $('#image_delete').data('uiid', uiid);
  });

  $('button[name=btnEdit]').on('click', function() {
    read_image($(this).closest('span'), function(data) {
      $('#profile_modal').modal('show');
      $uploader.croppie('bind', { url: data.data });
    });
  });

  $('button[name=btnDelete]').on('click', delete_image);

  $('#profile_remove').on('click', delete_profile);
});
