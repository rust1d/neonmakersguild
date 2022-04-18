$(function() {
  image_header = function(img) {
    img.closest('form').ben_image.value = img.dataset.clip;
    $('#image_header').css('background-image', `url(${img.dataset.clip})`);
  }

  image_insert = function(img) {
    var htm = `<img class="w-100 img-thumbnail" id=newimg src="${img.dataset.clip}" alt="${img.title}"></img>`;
    tinymce.activeEditor.execCommand('mceInsertContent', false, htm);
    var newimg = tinymce.activeEditor.getDoc().getElementById('newimg');
    newimg.removeAttribute('id');
    tinymce.activeEditor.execCommand('mceSelectNode', false, newimg);
    tinymce.activeEditor.execCommand('mceImage');
    tinymce.activeEditor.execCommand('mceRemoveNode');
  }

  $('#imageselect').on('click', 'img.clipable', function() {
    image_insert(this);
  });

  image_lookup = function(request, response) {
    request.usid = $('#imagesearch').data('usid');
    $.post({
      url: 'xhr.cfm?p=user/image/json',
      contentType: 'application/json',
      dataType: 'json',
      data: JSON.stringify(request),
      success: function(data) {
        image_options(data.data);
      }
    });
  }

  image_options = function(rows) {
    var $sel = $('#imageselect');
    $sel.find('div').remove();
    for (var idx in rows) {
      var row = rows[idx];
      var htm = `<div class='col-4 p-1'><img class='w-100 img-thumbnail clipable' src=${row.thumbnail} data-clip=${row.image} title='${row.filename} - ${row.dimensions}' /></div>`
      $sel.append(htm);
    }
  }

  $('#imagesearch').autocomplete({ minLength: 2, source: image_lookup, delay: 500 });
  setTimeout(() => { image_lookup({ term: '..' }) }, 1000);
});