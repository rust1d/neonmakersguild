$(function() {
  const $modal = $('#beiModal');
  const $content = $modal.find('.modal-content');
  let $comments, $comment, $input, $submit, $upload;

  const add_comment_image = function($input, id, src, filename='') {
    const $col = $('<div class="col-6 position-relative"></div>');
    const $img = $(`<img class='img-thumbnail' alt='${filename}' />`).attr('src', src);
    const $removeBtn = $('<button class="btn-delete-img btn-nmg-delete">&times;</button>');
    $removeBtn.on('click', function() {
      $col.remove();
    });
    $col.append($img).append($input).append($removeBtn);
    $comment.find('.comment-image').append($col);
  }

  const fetch_image_modal = function(data) {
    $.post({
      url: '/app/services/Images.cfc?method=bei',
      contentType: 'application/json',
      dataType: 'json',
      data: JSON.stringify(data),
      error: function(err) { console.log(err) },
      success: load_content
    });
  }

  const post_comment = function(formData) {
    $.post({
      url: '/app/services/Images.cfc?method=comment',
      processData: false,
      contentType: false,
      dataType: 'json',
      data: formData,
      error: function(err) { console.log(err) },
      success: load_content
    });
  }

  const load_content = function(results) {
    if (!results.success) {
      results.errors.forEach(err => {
        flash_error(err);
      });
      return;
    }
    if (results.data.comment) {
      return load_content_comment(results);
    }
    load_content_modal(results);
  }

  const load_content_comment = function(results) {
    $comments.append(results.data.content);
    $comments.find('.empty-comment').remove();
    updatable_counter(results.data.request.beiid);
  }

  const load_content_modal = function(results) {
    $content.html(results.data.content);
    $modal.modal('show');
    $comments = $content.find('.body-comments');
    $comment = $content.find('.comment-group');
    $input = $comment.find('.comment-input');
    $submit = $comment.find('.btnComment');
    $upload = $comment.find('.btnUpload');
  }

  const input_valid = debounce(function() {
    const val = $input.text().trim();
    $submit.toggleClass('text-secondary', val.length==0);
    if (val.length==0) {
      $input.empty();
    }
  }, 200);

  $('.image-grid img').on('click', function(ev) {
    fetch_image_modal(this.dataset);
  });

  $content.on('click', '.frame-nav button[data-nav]', function(ev) {
    fetch_image_modal(this.dataset);
  });

  $content.on('click', '#beiComment .btnComment', function(ev) {
    const val = $input.text().trim();
    if (val.length) {
      let data = $content.find('.modal-body').data();
      let params = {
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

  $content.on('input', '#beiComment .comment-input', input_valid);

  $content.on('keydown', '#beiComment .comment-input', function(ev) {
    if (ev.key==='Enter' && !ev.shiftKey) {
      ev.preventDefault();
      $submit.click();
    }
  });

  $content.on('dragover dragenter', '#beiComment', function(ev) {
    ev.preventDefault();
    ev.stopPropagation();
    $upload.find('i').removeClass('fa-camera').addClass('fa-upload');
  });

  $content.on('dragleave drop', '#beiComment', function(ev) {
    ev.preventDefault();
    ev.stopPropagation();
    $upload.find('i').removeClass('fa-upload').addClass('fa-camera');
  });

  $content.on('drop', '#beiComment', function(ev) {
    ev.preventDefault();
    ev.stopPropagation();
    const files = Array.from(ev.originalEvent.dataTransfer.files);
    process_images(files, add_comment_image);
  });

  $content.on('paste', '#beiComment .comment-input', function(ev) {
    const items = (ev.originalEvent || ev).clipboardData.items;
    const files = Array.from(items).filter(item => item.kind === 'file').map(item => item.getAsFile());
    process_images(files, add_comment_image);
  });
});
