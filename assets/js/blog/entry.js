$(function() {
  const $content = $('#entryPage');
  const commentId = '#entryComment';
  const $comments = $content.find('.post-comments');
  const $comment = $content.find('.comment-input-group');
  const $input = $comment.find('.comment-input');
  const $submit = $comment.find('button[name=btnComment]');
  const $upload = $comment.find('button[name=btnUpload]');

  const add_comment_image = function($input, id, src, filename = '') {
    const $col = $(`<div class="col-6 ${comment_image_class()} position-relative"></div>`);
    const $img = $(`<img class='img-fluid rounded' alt='${filename}' />`).attr('src', src);
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

});