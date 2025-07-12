SERVER = {};

const b64toBlob = function(b64Data, contentType='', sliceSize=512) {
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

const debounce = function(func, wait, immediate) {
  let timeout;
  return function() {
    const context = this;
    const args = arguments;
    const later = function() {
      timeout = null;
      if (!immediate) func.apply(context, args);
    }
    const callNow = immediate && !timeout;
    clearTimeout(timeout);
    timeout = setTimeout(later, wait);
    if (callNow) func.apply(context, args);
  }
}

const fetch_image_url = function(src, fld, success) {
  progress_overlay_show(1);
  $.ajax({
    url: '/app/services/Images.cfc?method=read',
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
        process_image(file, response.data.name, success).then(() => { progress_overlay_update() });
      } else {
        progress_overlay_update();
        alert('Image not returned from server.');
      }
    },
    error: function(xhr, status, error) {
      progress_overlay_update();
      alert('AJAX Error: ' + error);
    }
  });
}

const flash_clear = function(target='#flash-messages') {
  $(`${target}`).html('');
}

const flash_error = function(message, target='#flash-messages') {
  flash_message(message, 'danger', target);
  return false;
}

const flash_errors = function(messages, target='#flash-messages') {
  for (const message of messages) flash_error(message);
  return false;
}

const flash_message = function(message, type='success', target='#flash-messages') {
  var $msg = `<div class="alert fade show alert-${type} alert-dismissible" role="alert"><div>${message}</div><button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button></div>`;
  $(`${target}`).append($msg);
}

const flash_success = function(message, target='#flash-messages') {
  flash_message(message, 'success', target);
  return true;
}

const get_base64_ext = function(base64) {
  const match = base64.match(/^data:image\/([a-zA-Z0-9+]+);base64,/);
  const ext = match ? match[1].toLowerCase() : 'png';
  return ext === 'jpeg' ? 'jpg' : ext;
}

const is_img_url = function(src) {
  const url = src.trim();
  const isValidUrl = /^https?:\/\/[^\s]+$/i.test(url);
  const isImageExt = /\.(jpe?g|png|gif|bmp|webp|svg)(\?.*)?$/i.test(url);
  return isValidUrl && isImageExt;
}

const open_image_picker = function(add_image_callback, multiple='') {
  const $fileInput = $(`<input type='file' class='d-none' accept='image/*' ${multiple} />`);
  $fileInput.on('change', function(ev) {
    process_images(Array.from(this.files), add_image_callback); // ev.target.files
    $fileInput.remove();
  });
  $('body').append($fileInput);
  $fileInput.trigger('click');
}

const plural = function(cnt, data, add) {
  if (!add) add = 's';
  return (cnt==1) ? data : data + add;
}

const plural_label = function(cnt, data, add) {
  return cnt.toLocaleString('en-US') + ' ' + plural(cnt, data, add);
}

const postButton = function(btn) {
  // ANY input/button WITH onclick=postButton(this) WILL CREATE AND SUBMIT AN EMPTY FORM WITH JUST THE BUTTON NAME/VALUE
  var $frm = $(`<form method=post><input type=hidden name=${btn.name} value=${btn.value} /></form>`);
  $frm.appendTo('body').submit();
}

const process_images = async function(files, success) {
  const imgFiles = files.filter(f => f.type.startsWith('image/'));
  if (!imgFiles.length) return;

  progress_overlay_show(imgFiles.length);
  await new Promise(resolve => setTimeout(resolve, 50)); // let DOM render
  for (const file of imgFiles) {
    await process_image(file, file.name, success);
    progress_overlay_update();
  }
}

const process_image = function(file, originalName, success) {
  return new Promise((resolve, reject) => {
    const reader = new FileReader();

    reader.onload = function(ev) {
      const base64 = ev.target.result;
      const ext = get_base64_ext(base64);
      const uniqueId = `img_${crypto.randomUUID()}`;
      const baseName = originalName ? originalName.replace(/\.[^/.]+$/, '') : uniqueId;
      let finalName = `${baseName}.${ext}`;
      let finalType = file.type;

      const processAndAppend = function(blob, filename, mime) {
        const newFile = new File([blob], filename, { type: mime });
        const dt = new DataTransfer();
        dt.items.add(newFile);
        const $input = $(`<input id='${uniqueId}' type='file' name='${uniqueId}' class='d-none' />`);
        $input[0].files = dt.files;

        const reader2 = new FileReader();
        reader2.onload = function(eve) {
          success($input, uniqueId, eve.target.result, filename);
          resolve(); // IMAGE ADDED TO ROLL, ALL DONE
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

const progress_overlay_show = function(cnt) {
  $('#processingProgress').data('cnt', cnt).data('rem', cnt).css('width', '0%');
  $('#processingOverlay').removeClass('d-none');
}

const progress_overlay_update = function() {
  const $progress = $('#processingProgress');
  const cnt = $progress.data('cnt');
  let rem = Math.max(0, $progress.data('rem') - 1);
  $progress.data('rem', rem);
  const percent = Math.ceil((cnt - rem) / cnt * 100);
  $progress.css('width', `${percent}%`);
  if (rem===0) $('#processingOverlay').addClass('d-none');
}

const scaled_canvas = function(img) {
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

const slugger = function(txt) {
  return txt.toLowerCase().replace(/[^\w ]+/g, '').replace(/ +/g, '-');
}

const updatable_counter = function(id) {
  const $ctr = $(`span[data-id=${id}]`);
  if ($ctr.length==0) return;
  let cnt = parseInt($ctr.data('cnt') || 0) + 1;
  $ctr.html(cnt).data('cnt', cnt);
}

const uri_to_blob = function(uri) {
  const parts = uri.split(',');
  const mime = parts[0].split(':')[1].split(';')[0];
  const binary = atob(parts[1]);
  var data = [];
  for (var i=0; i<binary.length; i++) data.push(binary.charCodeAt(i));
  return new Blob([new Uint8Array(data)], { type: mime });
}

const valid_range = function(fld) {
  let min = parseFloat(fld.min) || 0;
  let max = parseFloat(fld.max) || min;
  let val = parseFloat(fld.value);
  if (isNaN(val)) val = max;
  if (val < min) val = min;
  if (max > min && val > max) val = max;
  return fld.value = val;
}

$(function() {
  $('script[data-json]').each(function() {
    let key = this.dataset.json;
    let data = JSON.parse(this.textContent);
    let def = data.constructor === Array ? [] : {};
    let obj = (key=='server') ? SERVER : SERVER[key] = SERVER[key] || def;
    for (let key in data) if (key) obj[key] = data[key];
  });

  $('body').on('click', '.clipable', function() {
    navigator.clipboard.writeText($(this).data('clip'));
    var el = $(this).addClass('clipped');
    setTimeout(() => { el.removeClass('clipped') }, 250);
  });

  $('a[data-link]').on('click', function() {
    if (this.dataset.link) {
      $.post({
        url: '/xhr.cfm?p=actions/link',
        cache: false,
        data: this.dataset.link,
        dataType: 'json',
        contentType: false,
        processData: false,
        error: function(err) { console.log(err) },
        success: function(data) { console.log(data) }
      });
    }
  });

  $('div.pager button[name=btnPage]').on('click', function() {
    var input = $('div.pager input[name=set_page]')[0];
    var searchParams = new URLSearchParams(window.location.search);
    searchParams.set('page', valid_range(input));
    window.location.search = searchParams.toString();
  });

  $('div.pager input[name=set_page]').on('keydown', function(ev) {
    if (ev.key === 'Enter' && !ev.shiftKey) {
      ev.preventDefault();
      $('div.pager button[name=btnPage]').click();
    }
  });

  $('#btnDelete').on('click', function(event) {
    if (!confirm('Are you sure you want to delete this record?')) event.preventDefault();
  });

  $('button[data-confirm]').on('click', function(event) {
    var msg = this.dataset.confirm;
    if (msg.length==0) msg = 'Are you sure?';
    if (!confirm(msg)) event.preventDefault();
  });
});
