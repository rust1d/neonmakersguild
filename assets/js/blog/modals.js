// .context TELLS:
//   WHAT SECTION OF THE SITE OPENED THE MODAL - frontpage, member stream or member page (user)
//   WHAT TYPE OF MODAL WAS OPENED - post or images
//   USID IF ON THE MEMBER POST PAGE

function create_post_modal(config = {}) {
  if (!config.type) throw new Error('create_post_modal: Missing parameters');

  const $modal = $(config.modalId || `#${config.type}Modal`);
  const commentId = config.commentId || `#${config.type}Comment`;
  const $content = $modal.find('.modal-content');
  let $comments, $comment, $input, $submit, $upload;

  const add_comment_image = function($input, id, src, filename = '') {
    const $col = $(`<div class="col-6 ${comment_image_class()} position-relative"></div>`);
    const $img = $(`<img class='img-fluid' alt='${filename}' />`).attr('src', src);
    const $removeBtn = $("<button class='btn-close btn-close-delete'></button>");
    $removeBtn.on('click', function() { $col.remove(); enable_upload(); });
    $col.append($img).append($input).append($removeBtn);
    $comment.find('.comment-image').append($col);
  }

  const comment_image_class = function() {
    const width = $comment.closest('.scrollable').width();
    return width < 400 ? 'col-md-4' : 'col-md-2';
  }

  const enable = function($btn, state) {
    $btn.toggleClass('text-nmg', state).toggleClass('text-secondary', !state).prop('disabled', !state);
  }

  const enable_submit = function(state=false) {
    enable($submit, state);
  }

  const enable_upload = function() {
    enable($upload, $comment.find('.comment-image').length===0);
  }

  const handle_error = function(err) {
    const response = err?.responseJSON;
    if (response?.errors?.length) {
      response.errors.forEach(flash_error);
    } else {
      flash_error('An unexpected error occurred.');
    }
  }

  const hide = function() {
    $modal.modal('hide');
  }

  const input_valid = function() {
    const val = $input.text().trim();
    enable_submit(val.length>0);
    if (!val.length) $input.empty();
  }

  const load_content = function(results) {
    if (!results.success) return handle_error({ responseJSON: results });
    if (results.data.comment) return load_content_comment(results);
    load_content_modal(results);
  }

  const load_content_comment = function(results) {
    const $newComment = $(results.data.content);
    $comments.append($newComment);
    $comments.find('.empty-comment').remove();
    updatable_counter(results.data.counter);
    $content.find('.scrollable').animate({ scrollTop: $newComment.offset().top }, 700);
  }

  const load_content_modal = function(results) {
    $content.html(results.data.content);
    $comments = $content.find('.post-comments');
    $comment = $content.find('.comment-input-group');
    $input = $comment.find('.comment-input');
    $submit = $comment.find('button[name=btnComment]');
    $upload = $comment.find('button[name=btnUpload]');
    show_modal();
  }

  const load_modal = function(data, nav) {
    let params = { ...data }
    if (nav) {
      params.section = data.section;
      params.type = config.context.type; // PASS ORIGINAL CLICK CONTEXT
      params.direction = data.direction;
    }
    $.post({
      url: `/app/services/Images.cfc?method=${config.type}`,
      contentType: 'application/json',
      dataType: 'json',
      data: JSON.stringify(params),
      error: handle_error,
      success: load_content
    });
  }

  const open = function(data) {
    config.context = data; // SAVE THE STARTING CLICK
    load_modal(data, 1);
  }

  const post_comment = function(formData) {
    enable_submit(false);
    return $.post({
      url: '/app/services/Images.cfc?method=comment',
      headers: { 'X-Requested-With': 'XMLHttpRequest' },
      processData: false,
      contentType: false,
      dataType: 'json',
      data: formData,
      error: handle_error,
      always: enable_submit,
      success: load_content
    });
  }

  const show_modal = function() {
    for (const key in SERVER.handlers) {
      if (key!=config.type) SERVER.handlers[key].hide();
    }
    $modal.modal('show');
    $modal.one('shown.bs.modal', function() { // .one FIRES ONLY FIRST TIME SHOWN
      $input.trigger('focus');
    });
  }

  $content.on('click', '.image-grid img', function(ev) {
    SERVER.handlers.bei.open(this.dataset);
  });

  $content.on('click', 'a.post', function(ev) {
    ev.preventDefault();
    SERVER.handlers.ben.open(this.dataset);
  });

  $(document).on('keydown', function(ev) {
    if (!$modal.is(':visible')) return;
    const isTyping = (
      ['INPUT', 'TEXTAREA'].includes(document.activeElement.tagName) || document.activeElement.isContentEditable
    );
    if (isTyping) return;

    if (ev.key === 'ArrowLeft') {
      $content.find('.frame-nav button[data-direction="prev"]').trigger('click');
    } else if (ev.key === 'ArrowRight') {
      $content.find('.frame-nav button[data-direction="next"]').trigger('click');
    }
  });


  $content.on('click', '.frame-nav button[data-direction]', function(ev) { // ONLY ON IMAGES
    load_modal(this.dataset, 1);
  });

  $content.on('click', `${commentId} button[name=btnUpload]`, function(ev) {
    open_image_picker(add_comment_image, 'multiple');
  });

  $content.on('click', `${commentId} button[name=btnComment]`, function(ev) {
    const val = $input.text().trim();
    if (val.length) {
      const data = $content.find('.post-body').data();
      const params = {
        beiid: data.beiid,
        benid: data.benid,
        comment: val,
        filenames: []
      }
      const formData = new FormData();
      $comment.find('input[type=file]').each(function() {
        for (const file of this.files) {
          formData.append('images', file);
          params.filenames.push(file.name);
        }
      });
      formData.append('p', JSON.stringify(params));
      post_comment(formData);
      $input.empty();
      $comment.find('.comment-image').empty();
      $submit.removeClass('active');
    }
  });

  $content.on('input', `${commentId} .comment-input`, debounce(input_valid, 200));
  $content.on('keydown', `${commentId} .comment-input`, function(ev) {
    if (ev.key === 'Enter' && !ev.shiftKey) {
      ev.preventDefault();
      $submit.click();
    }
  });

  $content.on('dragover dragenter', commentId, function(ev) {
    ev.preventDefault();
    ev.stopPropagation();
    $upload.find('i').removeClass('fa-camera').addClass('fa-upload');
  });

  $content.on('dragleave drop', commentId, function(ev) {
    ev.preventDefault();
    ev.stopPropagation();
    $upload.find('i').removeClass('fa-upload').addClass('fa-camera');
  });

  $content.on('drop', commentId, function(ev) {
    ev.preventDefault();
    ev.stopPropagation();
    const files = Array.from(ev.originalEvent.dataTransfer.files);
    process_images(files, add_comment_image);
  });

  $content.on('paste', `${commentId} .comment-input`, function(ev) {
    const items = (ev.originalEvent || ev).clipboardData.items;
    const files = Array.from(items).filter(i => i.kind === 'file').map(i => i.getAsFile());
    process_images(files, add_comment_image);
  });

  return SERVER.handlers[config.type] = { open, hide } // MAKES THESE METHODS PUBLIC
}

SERVER.handlers = {}

$(function() {
  create_post_modal({ type: 'ben' });
  create_post_modal({ type: 'bei' });

  // Hook triggers
  $('a.post').on('click', function(ev) {
    if (this.dataset.target=='focus') {
      setTimeout(()=>{ $('.comment-input').focus() }, 200);
      $inp = $('.comment-input')
      $inp.get(0).scrollIntoView({ behavior: 'smooth', block: 'center' });
      $inp.focus();
      return;
    }
    ev.preventDefault();
    SERVER.handlers.ben.open(this.dataset);
  });

  $('.image-grid img').on('click', function(ev) {
    SERVER.handlers.bei.open(this.dataset);
  });
});
