$(function() {
  SERVER.activeEditor = null;

  let toolbar_groups = {
    aligning: {
      icon: 'align-center',
      items: 'alignleft | aligncenter | alignright | alignjustify | alignnone | indent | outdent'
    },
    editing: {
      icon: 'edit-block',
      items: 'selectall | cut | copy | paste | pastetext | removeformat | remove'
    },
    font: {
      icon: 'typography',
      items: 'fontfamily fontsize | forecolor backcolor'
    },
    lists: {
      icon: 'unordered-list',
      items: 'numlist bullist'
    },
    styling: {
      icon: 'paragraph',
      items: 'blocks | bold | italic | blockquote | underline | strikethrough | subscript | superscript'
    }
  }

  let toolbar_summary = {
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
    styling: {
      icon: 'paragraph',
      tooltip: 'Styling',
      items: 'blocks | bold italic | blockquote | underline | strikethrough | subscript | superscript'
    }
  }

  let tiny_params = {
    license_key: 'gpl',
    promotion: false,
    menubar: 'edit insert view format table help',
    plugins: 'autolink autosave code fullscreen help image importcss link lists media preview searchreplace table visualblocks visualchars wordcount',
    toolbar: 'fullscreen | code | undo redo | editing | styling | font | aligning | lists | link unlink | image media',
    toolbar_groups: toolbar_groups,
    font_family_formats: 'Select Font=system-ui;Andale Mono=andale mono,times; Arial Black=arial black,avant garde; Arial=arial,helvetica,sans-serif; Arimo=arimo; Book Antiqua=book antiqua,palatino; Comic Sans MS=comic sans ms,sans-serif; Courier New=courier new,courier; Georgia=georgia,palatino; Helvetica=helvetica; Impact=impact,chicago; Montserrat=montserrat; Permanent Marker=permanent marker; Poppins=poppins; Roboto=roboto; Symbol=symbol; Tahoma=tahoma,arial,helvetica,sans-serif; Terminal=terminal,monaco; Times New Roman=times new roman,times; Trebuchet MS=trebuchet ms,geneva; Verdana=verdana,geneva; Webdings=webdings; Wingdings=wingdings,zapf dingbats;',
    toolbar_mode: 'floating',
    image_class_list: [
      { title: 'Normal Size', value: 'img-fluid my-3' },
      { title: 'Width', menu: [
        { title: 'Width 100% no padding', value: 'img-fluid w-100' },
        { title: 'Width 100%', value: 'img-fluid w-100 my-3' },
        { title: 'Width 75%', value: 'img-fluid w-75 p-1 m-3' },
        { title: 'Width 75%, Align Right', value: 'img-fluid w-75 p-1 m-3 float-end' },
        { title: 'Width 50%', value: 'img-fluid w-50 p-1 m-3 float-start' },
        { title: 'Width 50%, Align Right', value: 'img-fluid w-50 p-1 m-3 float-end' },
        { title: 'Width 25%', value: 'img-fluid w-25 p-1 m-3 float-start' },
        { title: 'Width 25%, Align Right', value: 'img-fluid w-25 p-1 m-3 float-end' }
      ]}
    ],
    image_list: (success) => {
      success($('#imageselect').find('img').map(function() { return { value: this.dataset.clip, title: this.title }}));
    },
    table_class_list: [
      { title: '% Width', value: 'table table-borderless' },
      { title: 'Fit Contents', value: 'table w-auto table-borderless' },
      { title: '% Width/Borders', value: 'table border border-nmg' },
      { title: 'Fit Contents/Borders', value: 'table w-auto border border-nmg' },
      { title: 'Data Table', value: 'table table-hover border border-nmg' }
    ],
    invalid_styles: {
      'table': 'height border-collapse',
      'tr' : 'width height',
      'th' : 'width height',
      'td' : 'width height'
    },
    skin_url: '/assets/css/admin',
    content_css: 'https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css',
    image_dimensions: false,
    image_description: true,
    object_resizing: false,
    image_advtab: false,
    image_caption: true,
    table_default_attributes: { },
    table_default_styles: { width: '' },
    table_appearance_options: false,
    table_advtab: false,
    table_cell_advtab: false,
    table_row_advtab: false,
    table_grid: false,
    table_use_colgroups: false,
    relative_urls : false,
    remove_script_host : true,
    visualblocks_default_state: true
  }

  let tiny_summary = {
    license_key: 'gpl',
    promotion: false,
    menubar: 'edit view help',
    plugins: 'autolink autosave code fullscreen help importcss link preview searchreplace visualblocks visualchars wordcount',
    toolbar: 'fullscreen | code | undo redo | editing | styling | font | link unlink',
    toolbar_groups: toolbar_summary,
    font_family_formats: 'Select Font=system-ui;Andale Mono=andale mono,times; Arial Black=arial black,avant garde; Arial=arial,helvetica,sans-serif; Arimo=arimo; Book Antiqua=book antiqua,palatino; Comic Sans MS=comic sans ms,sans-serif; Courier New=courier new,courier; Georgia=georgia,palatino; Helvetica=helvetica; Impact=impact,chicago; Montserrat=montserrat; Permanent Marker=permanent marker; Poppins=poppins; Roboto=roboto; Symbol=symbol; Tahoma=tahoma,arial,helvetica,sans-serif; Terminal=terminal,monaco; Times New Roman=times new roman,times; Trebuchet MS=trebuchet ms,geneva; Verdana=verdana,geneva; Webdings=webdings; Wingdings=wingdings,zapf dingbats;',
    toolbar_mode: 'floating',
    skin_url: '/assets/css/admin',
    content_css: 'https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css',
    relative_urls : false,
    remove_script_host : true,
    visualblocks_default_state: true
  }

  let tiny_forum = {
    license_key: 'gpl',
    promotion: false,
    menubar: false,
    plugins: 'autolink autosave code fullscreen help link lists media preview visualblocks visualchars wordcount',
    toolbar: 'fullscreen | undo redo | editing | styling | font | aligning | lists | link unlink customImageBtn media',
    toolbar_groups: toolbar_groups,
    font_family_formats: 'Select Font=system-ui; Arial=arial,helvetica,sans-serif; Courier New=courier new,courier; Georgia=georgia,palatino; Helvetica=helvetica; Impact=impact; monospace=Menlo,Monaco,monospace; Montserrat=montserrat; Permanent Marker=permanent marker; Poppins=poppins; Roboto=roboto; Segoe=Segoe UI; Tahoma=tahoma,arial; Times New Roman=times new roman,times; Trebuchet MS=trebuchet ms,geneva; Verdana=verdana,geneva;',
    toolbar_mode: 'floating',
    skin_url: '/assets/css/nmg',
    relative_urls : false,
    remove_script_host : true,
    visualblocks_default_state: true,
    setup: (editor) => {
      const $drop =$('#imageDropdown');
      editor.on('init', function() {
        const iframeDoc = editor.getDoc();
        if (iframeDoc) {
          $(iframeDoc).on('mousedown', function() {
            bootstrap.Dropdown.getOrCreateInstance($drop[0]).hide();
          });
        }
      });
      editor.ui.registry.addButton('customImageBtn', {
        icon: 'camera',
        tooltip: 'Upload Image',
        onAction: () => {
          SERVER.activeEditor = editor;
          $drop.data('roll', editor.targetElm.dataset.roll || 'photo_roll');
          const $btn = $(editor.getContainer()).find('button[data-mce-name=customimagebtn]').last();
          const offset = $btn.offset();
          const top = offset.top + $btn.outerHeight()
          $drop.css({ top: `${top}px` }).addClass('show').find('.dropdown-menu').addClass('show');
        }
      });
      editor.on('drop', function(ev) {
        const dt = ev.dataTransfer;
        if (!dt || !dt.files?.length) return;
        const files = Array.from(dt.files);
        ev.preventDefault();
        ev.stopPropagation();
        process_images(files, add_to_roll);
      });
      editor.on('paste', function(ev) {
        const items = (ev.clipboardData || ev.originalEvent?.clipboardData)?.items || [];
        const files = Array.from(items).filter(item => item.kind==='file').map(item => item.getAsFile());
        if (!files.length) return;
        ev.preventDefault();
        process_images(files, add_to_roll);
      });
    }
  }

  $('textarea.tiny-mce').each(function() {
    var high = 160 + this.rows * 20;
    var params = { height: high, target: this }
    tinymce.init({ ...tiny_params, ...params });
  });

  $('textarea.tiny-sum').each(function() {
    var high = 160 + this.rows * 20;
    var params = { height: high, target: this }
    tinymce.init({ ...tiny_summary, ...params });
  });

  init_tinyforum = function(txt) {
    var high = 160 + txt.rows * 20;
    var params = { height: high, target: txt }
    tinymce.init({ ...tiny_forum, ...params });
  }

  $('textarea.tiny-forum').each(function() {
    init_tinyforum(this);
  });

  $(document).on('mousedown', function(ev) {
    const $drop = $('#imageDropdown');
    if ($drop.length==0) return;
    if (!$drop.is(ev.target) && $drop.has(ev.target).length===0) {
      bootstrap.Dropdown.getOrCreateInstance($drop[0]).hide();
    }
  });
});
