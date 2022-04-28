$(function() {
  let toolbar_groups ={
    aligning: {
      icon: 'align-center',
      tooltip: 'Alignment',
      items: 'alignleft aligncenter alignright alignjustify alignnone'
    },
    editing: {
      icon: 'edit-block',
      tooltip: 'Edit',
      items: 'selectall | cut copy paste pastetext removeformat remove'
    },
    font: {
      icon: 'change-case',
      tooltip: 'Font, Size, Color',
      items: 'fontfamily fontsize forecolor backcolor'
    },
    lists: {
      icon: 'list-bull-circle',
      tooltip: 'Lists',
      items: 'numlist bullist | indent outdent'
    },
    styling: {
      icon: 'paragraph',
      tooltip: 'Styling',
      items: 'blocks | bold italic | blockquote | underline strikethrough | subscript superscript'
    }
  };

  let tiny_params = {
    plugins: 'autolink autosave code fullscreen help image importcss link lists media preview searchreplace table visualchars wordcount',
    toolbar: 'fullscreen | code | undo redo | editing | styling | font | aligning | lists | link unlink | image media',
    toolbar_groups: toolbar_groups,
    font_family_formats: 'Select Font=system-ui;Andale Mono=andale mono,times; Arial Black=arial black,avant garde; Arial=arial,helvetica,sans-serif; Arimo=arimo; Book Antiqua=book antiqua,palatino; Comic Sans MS=comic sans ms,sans-serif; Courier New=courier new,courier; Georgia=georgia,palatino; Helvetica=helvetica; Impact=impact,chicago; Montserrat=montserrat; Permanent Marker=permanent marker; Poppins=poppins; Roboto=roboto; Symbol=symbol; Tahoma=tahoma,arial,helvetica,sans-serif; Terminal=terminal,monaco; Times New Roman=times new roman,times; Trebuchet MS=trebuchet ms,geneva; Verdana=verdana,geneva; Webdings=webdings; Wingdings=wingdings,zapf dingbats;',
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
    skin_url: '/assets/css/admin',
    content_css: 'https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css',
    image_dimensions: false,
    image_description: true,
    object_resizing: false,
    image_advtab: false,
    table_appearance_options: false,
    relative_urls : false,
    remove_script_host : false,
  };

  $('textarea.tiny-mce').each(function() {
    var high = 160 + this.rows * 20;
    var params = { height: high, target: this }
    tinymce.init({ ...tiny_params, ...params });
  });

  let tiny_forum = {
    plugins: 'autolink autosave fullscreen help image link lists media preview visualchars wordcount',
    toolbar: 'fullscreen | undo redo | editing | styling | font | aligning | lists | link unlink | image media',
    toolbar_groups: toolbar_groups,
    font_family_formats: 'Select Font=system-ui;Andale Mono=andale mono,times; Arial Black=arial black,avant garde; Arial=arial,helvetica,sans-serif; Arimo=arimo; Book Antiqua=book antiqua,palatino; Comic Sans MS=comic sans ms,sans-serif; Courier New=courier new,courier; Georgia=georgia,palatino; Helvetica=helvetica; Impact=impact,chicago; Montserrat=montserrat; Permanent Marker=permanent marker; Poppins=poppins; Roboto=roboto; Symbol=symbol; Tahoma=tahoma,arial,helvetica,sans-serif; Terminal=terminal,monaco; Times New Roman=times new roman,times; Trebuchet MS=trebuchet ms,geneva; Verdana=verdana,geneva; Webdings=webdings; Wingdings=wingdings,zapf dingbats;',
    toolbar_mode: 'floating',
    skin_url: '/assets/css/nmg',
    relative_urls : false,
    remove_script_host : false,
  };

  $('textarea.tiny-forum').each(function() {
    var high = 160 + this.rows * 20;
    var params = { height: high, target: this }
    tinymce.init({ ...tiny_forum, ...params });
  });
});
