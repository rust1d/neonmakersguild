function active_roll() {
  const roll = $('#imageDropdown').data('roll') || 'photo_roll';
  return $(`#${roll}`);
}

function add_to_roll($input, id, src, filename='') {
  const $col = $('<div class="col-3 col-xl-2 roll-img"></div>');
  const $img = $(`<img class='w-100 img-thumbnail' data-caption='cap_${id}' alt='${filename}' />`).attr('src', src);
  const $cap = $(`<input type='hidden' id='cap_${id}' name='cap_${id}' />`);
  const $roll = active_roll();
  const $removeBtn = $('<button class="btn-delete-img btn-nmg-delete">&times;</button>');
  $removeBtn.on('click', function() {
    // $(`#${id}`).remove(); // file input goes away with the pic/$col
    $col.remove();
    show_edit_all($roll); //
  });
  $col.append($img).append($removeBtn).append($input).append($cap);
  $roll.append($col);
  show_edit_all($roll);
}

function b64toBlob(b64Data, contentType='', sliceSize=512) {
  const byteChars = atob(b64Data);
  const byteArrays = [];
  for (let offset = 0; offset < byteChars.length; offset += sliceSize) {
    const slice = byteChars.slice(offset, offset + sliceSize);
    const byteNums = new Array(slice.length);
    for (let i = 0; i < slice.length; i++) {
      byteNums[i] = slice.charCodeAt(i);
    }
    byteArrays.push(new Uint8Array(byteNums));
  }
  return new Blob(byteArrays, { type: contentType });
}

function current_images($roll) {
  $roll = $roll || active_roll();
  return $roll.find('img');
}

function fetch_image(src, fld) {
  start_progress(1);
  $.ajax({
    url: '/app/services/Img64.cfc?method=read',
    type: 'POST',
    contentType: 'application/json',
    dataType: 'json',
    data: JSON.stringify({ src: src }),
    success: function(response) {
      fld.value = '';
      if (response.success && response.data && response.data.img) {
        const ext = get_base64_ext(response.data.img);
        const blob = b64toBlob(response.data.img.split(',')[1], `image/${ext}`);
        const file = new File([blob], response.data.name, { type: blob.type });
        process_image(file, response.data.name).then(() => { update_progress() });
      } else {
        update_progress();
        alert('Image not returned from server.');
      }
    },
    error: function(xhr, status, error) {
      update_progress();
      alert('AJAX Error: ' + error);
    }
  });
}

function is_img_url(src) {
  const url = src.trim();
  const isValidUrl = /^https?:\/\/[^\s]+$/i.test(url);
  const isImageExt = /\.(jpe?g|png|gif|bmp|webp|svg)(\?.*)?$/i.test(url);
  return isValidUrl && isImageExt;
}

async function process_files(files) {
  const imgFiles = files.filter(f => f.type.startsWith('image/'));
  if (!imgFiles.length) return;

  start_progress(imgFiles.length);
  await new Promise(resolve => setTimeout(resolve, 50)); // let DOM render
  for (const file of imgFiles) {
    await process_image(file, file.name);
    update_progress();
  }
}

function process_image(file, originalName) {
  return new Promise((resolve, reject) => {
    const reader = new FileReader();

    reader.onload = function(ev) {
      const base64 = ev.target.result;
      const ext = get_base64_ext(base64);
      const uniqueId = `img_${crypto.randomUUID()}`;
      const baseName = originalName ? originalName.replace(/\.[^/.]+$/, '') : uniqueId;
      let finalName = `${baseName}.${ext}`;
      let finalType = file.type;

      const processAndAppend = (blob, filename, mime) => {
        const newFile = new File([blob], filename, { type: mime });
        const dt = new DataTransfer();
        dt.items.add(newFile);
        const $input = $(`<input id='${uniqueId}' type='file' name='${uniqueId}' class='d-none' />`);
        $input[0].files = dt.files;
        // $('#hidden-inputs').append($input);

        const reader2 = new FileReader();
        reader2.onload = ev2 => {
          add_to_roll($input, uniqueId, ev2.target.result, filename);
          resolve(); // Only resolve after image is added to roll
        }
        reader2.onerror = reject;
        reader2.readAsDataURL(newFile);
      }

      const img = new Image();
      img.crossOrigin = 'anonymous';
      img.onload = function() {
        const canvas = scaled_canvas(img);
        if (ext==='webp') {
          finalName = `${baseName}.jpg`;
          finalType = 'image/jpeg';
        }
        canvas.toBlob(blob => {
          if (blob) {
            processAndAppend(blob, finalName, finalType);
          } else {
            reject(new Error('Failed to convert canvas to Blob.'));
          }
        }, finalType, 0.85);
      }
      img.onerror = reject;
      img.src = base64;
    }

    reader.onerror = reject;
    reader.readAsDataURL(file);
  });
}

function scaled_canvas(img) {
  const scale = Math.min(1, SERVER.forum_image_max_size / Math.max(img.width, img.height));
  const newWidth = Math.round(img.width * scale);
  const newHeight = Math.round(img.height * scale);
  const canvas = document.createElement('canvas');
  canvas.width = newWidth;
  canvas.height = newHeight;
  const ctx = canvas.getContext('2d');
  ctx.drawImage(img, 0, 0, newWidth, newHeight);
  return canvas;
}

function show_edit_all($roll) {
  $('#btnEditCaptions').toggleClass('displayed', current_images($roll).length>1);
}

function start_progress(cnt) {
  $('#processingProgress').data('cnt', cnt).data('rem', cnt).css('width', '0%');
  $('#processingOverlay').removeClass('d-none');
}

function update_progress() {
  const $progress = $('#processingProgress');
  const cnt = $progress.data('cnt');
  let rem = Math.max(0, $progress.data('rem') - 1);
  $progress.data('rem', rem);
  const percent = Math.ceil((cnt - rem) / cnt * 100);
  $progress.css('width', `${percent}%`);
  if (rem===0) $('#processingOverlay').addClass('d-none');
}

$(function() {
  const $dropZone = $('#uploadDropZone');
  const $filePicker = $('#filePicker');

  $filePicker.on('change', function() {
    process_files(Array.from(this.files));
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
    process_files(Array.from(ev.originalEvent.dataTransfer.files));
  });

  $(document).on('paste', function(ev) {
    const items = (ev.originalEvent || ev).clipboardData.items;
    const files = Array.from(items).filter(item => item.kind==='file').map(item => item.getAsFile());
    process_files(files);
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
    if (is_img_url(fld.value)) fetch_image(fld.value, fld);
  });

  $('#btnEditCaptions').on('click', function() {
    const $captions = $('#captions');
    $captions.empty();
    current_images().each(function() {
      const id = this.dataset.caption;
      const caption = $(`#${id}`).val();
      const inputGroup = `
        <div class='col-md-6 col-lg-4'>
          ${this.outerHTML}
          <div class='pt-2'>
            <textarea class='form-control form-control-sm' data-id='${id}' rows='3' placeholder='Caption'>${caption}</textarea>
          </div>
        </div>
      `;
      $captions.append(inputGroup);
    });
  });

  $('#btnSaveCaptions').on('click', function() {
    const $captions = $('#captions');
    $captions.find('textarea').each(function() {
      $(`#${this.dataset.id}`).val(this.value);
    });
  });
});
