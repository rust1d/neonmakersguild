$(function() {
  tinymce.init({
    selector: 'textarea.tiny-mce',
    plugins: 'autolink autosave code fullscreen help image importcss lists media preview table visualchars wordcount',
    toolbar: 'code fullscreen image media preview restoredraft table visualchars wordcount',
    toolbar_mode: 'floating',
    image_class_list: [
      { title: 'None', value: '' },
      { title: 'Width', menu: [
        { title: '100%', value: 'w-100' },
        { title: '75%', value: 'w-75' },
        { title: '50%', value: 'w-50' },
        { title: '25%', value: 'w-25' }
      ]}
    ],
    content_css: 'https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css',
    image_dimensions: false,
    object_resizing: false,
    image_advtab: true,
    table_appearance_options: false,
    relative_urls : false,
    remove_script_host : false,
  });

  $('body').on('click', '.clipable', function() {
    navigator.clipboard.writeText($(this).data('clip'));
    var el = $(this).addClass('clipped');
    setTimeout(() => { el.removeClass('clipped') }, 250);
  });

  lookup = function(request, response) {
    request.usid = $('#imagesearch').data('usid');
    $.post({
      url: 'xhr.cfm?p=user/image/json',
      contentType: 'application/json',
      dataType: 'json',
      data: JSON.stringify(request),
      success: function(data) {
        fill_select(data.data);
      }
    });
  }

  fill_select = function(rows) {
    var $sel = $('#imageselect');
    $sel.find('div').remove();
    for (var idx in rows) {
      var row = rows[idx];
      var htm = `<div class='col-3 p-1'><img class='w-100 img-thumbnail clipable' src=${row.thumbnail} data-clip=${row.image} title='${row.filename} - ${row.dimensions}' /></div>`
      $sel.append(htm);
    }
  }

  uri_to_blob = function(uri) {
    const parts = uri.split(',');
    const mime = parts[0].split(':')[1].split(';')[0];
    const binary = atob(parts[1]);
    var data = [];
    for (var i=0; i<binary.length; i++) data.push(binary.charCodeAt(i));
    return new Blob([new Uint8Array(data)], { type: mime });
  }

  $('#imagesearch').autocomplete({ minLength: 2, source: lookup, delay: 500 });
});
