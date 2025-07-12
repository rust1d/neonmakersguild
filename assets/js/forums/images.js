function active_roll() {
  const roll = $('#imageDropdown').data('roll') || 'photo_roll';
  return $(`#${roll}`);
}

function add_to_roll($input, id, src, filename='') {
  const $col = $('<div class="col-3 col-xl-2 roll-img text-center"></div>');
  const $img = $(`<img class='img-fluid' data-caption='cap_${id}' alt='${filename}' />`).attr('src', src);
  const $cap = $(`<input type='hidden' id='cap_${id}' name='cap_${id}' />`);
  const $roll = active_roll();
  const $removeBtn = $("<button class='btn-close btn-close-delete'></button>");
  $removeBtn.on('click', function() {
    $col.remove();
    show_edit_all($roll);
  });
  $col.append($img).append($removeBtn).append($input).append($cap);
  $roll.append($col);
  show_edit_all($roll);
}

function current_images($roll) {
  $roll = $roll || active_roll();
  return $roll.find('img');
}

function show_edit_all($roll) {
  $('#btnEditCaptions').toggleClass('displayed', current_images($roll).length>1);
}

$(function() {
  const $dropZone = $('#uploadDropZone');
  const $filePicker = $('#filePicker');

  $filePicker.on('change', function() {
    process_images(Array.from(this.files), add_to_roll);
    this.value = '';
  });

  $dropZone.on('dragover dragenter', function(ev) {
    ev.preventDefault();
    ev.stopPropagation();
    $dropZone.addClass('border-primary bg-nmg');
  });

  $dropZone.on('dragleave drop', function(ev) {
    ev.preventDefault();
    ev.stopPropagation();
    $dropZone.removeClass('border-primary bg-nmg');
  });

  $dropZone.on('drop', function(ev) {
    ev.preventDefault();
    ev.stopPropagation();
    process_images(Array.from(ev.originalEvent.dataTransfer.files), add_to_roll);
  });

  $(document).on('paste', function(ev) {
    const items = (ev.originalEvent || ev).clipboardData.items;
    const files = Array.from(items).filter(item => item.kind==='file').map(item => item.getAsFile());
    process_images(files, add_to_roll);
  });

  $('#btnOpenPicker').on('click', function() {
    $filePicker.click();
  });

  $('button[data-bs-dismiss="#imageDropdown"]').on('click', function() {
    const $drop = $(this.dataset.bsDismiss);
    bootstrap.Dropdown.getOrCreateInstance($drop[0]).hide();
  });

  $('#imageUrlInput').on('paste', function() {
    setTimeout(() => $('#btnAttach').trigger('click'), 10);
  });

  $('#btnAttach').on('click', function() {
    let fld = $('#imageUrlInput')[0];
    if (is_img_url(fld.value)) fetch_image_url(fld.value, fld, add_to_roll);
  });

  $('#btnEditCaptions').on('click', function() {
    const $captions = $('#captions');
    $captions.empty();
    const imgs = current_images();

    imgs.each(function() {
      const id = this.dataset.caption;
      const caption = $(`#${id}`).val();
      const img = $(this.outerHTML).removeClass('img-thumbnail w-100')[0];
      const inputGroup = `
        <div class='col-md-6'>
          <div class='content-card'>
            <div class='blur-frame'>
              ${img.outerHTML}
            </div>
            <div class='p-2'>
              <textarea class='form-control form-control-sm border-secondary-subtle' data-id='${id}' rows='3' placeholder='Caption'>${caption}</textarea>
            </div>
          </div>
        </div>
      `;
      $captions.append(inputGroup);
    });
    $captions.find('.blur-frame').each(function() {
      const src = $(this).find('img').attr('src');
      $(this).css('background-image', `url(${src})`);
    });
  });

  $('#btnSaveCaptions').on('click', function() {
    const $captions = $('#captions');
    $captions.find('textarea').each(function() {
      $(`#${this.dataset.id}`).val(this.value.trim());
    });
    $('#editAllModal').modal('hide');
  });
});
