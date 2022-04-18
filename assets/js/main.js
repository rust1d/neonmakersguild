$(function() {
  tinymce.init({
    selector: 'textarea.tiny-mce',
    plugins: 'autolink autosave code fullscreen help image importcss lists media preview table visualchars wordcount',
    toolbar: 'code fullscreen image media preview restoredraft table visualchars wordcount',
    toolbar_mode: 'floating',
    image_class_list: [
      { title: 'None', value: 'w-100 my-3' },
      { title: 'Width', menu: [
        { title: 'Width 100%', value: 'w-100 my-3' },
        { title: 'Width 75%', value: 'w-75 p-1 m-3' },
        { title: 'Width 50%', value: 'w-50 p-1 m-3 float-start' },
        { title: 'Width 50%, Align Right', value: 'w-50 p-1 m-3 float-end' },
        { title: 'Width 25%', value: 'w-25 p-1 m-3 float-start' },
        { title: 'Width 25%, Align Right', value: 'w-25 p-1 m-3 float-end' }
      ]}
    ],
    image_list: (success) => {
      success($('#imageselect').find('img').map(function() { return { value: this.dataset.clip, title: this.title }}));
    },
    skin_url: '/assets/css',
    // skin: 'nmg',
    content_css: 'https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css',
    image_dimensions: false,
    image_description: true,
    object_resizing: false,
    image_advtab: false,
    table_appearance_options: false,
    relative_urls : true,
    remove_script_host : false,
  });

  $('body').on('click', '.clipable', function() {
    navigator.clipboard.writeText($(this).data('clip'));
    var el = $(this).addClass('clipped');
    setTimeout(() => { el.removeClass('clipped') }, 250);
  });

  uri_to_blob = function(uri) {
    const parts = uri.split(',');
    const mime = parts[0].split(':')[1].split(';')[0];
    const binary = atob(parts[1]);
    var data = [];
    for (var i=0; i<binary.length; i++) data.push(binary.charCodeAt(i));
    return new Blob([new Uint8Array(data)], { type: mime });
  }
});
