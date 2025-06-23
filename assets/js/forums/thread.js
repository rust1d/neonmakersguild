$(function() {
  const frm = $('#edit_message')[0].form;
  const $popin = $('#edit_popin');
  const $editroll = $('#edit_roll');
  let remove_fiids = [];

  $('a.message-edit').on('click', function(event) {
    event.preventDefault();
    frm.fmid.value = this.dataset.key;
    const $row = $(`#message-${frm.fmid.value}`);
    const $msg = $row.find('.message');
    const $body = $msg.find('.body');
    const $roll = $row.find('.message-roll');

    tinymce.get('edit_message').destroy(); // CLEAR EXISTING EDIT
    frm.edit_message.value =$body.text(); // SET EDIT MSG
    init_tinyforum(frm.edit_message);

    $editroll.empty(); // EMPTY EDIT IMAGE ROLL
    $roll.addClass('d-none').find('img').each(function() { // CLONE EDITED MSG IMAGES INTO EDIT ROLL
      const $col = $('<div class="col-3 col-xl-2 position-relative">').prependTo($editroll);
      $(this).clone().appendTo($col);
      const $btn = $('<button type="button" class="btn-delete-img btn-nmg-delete">&times;</button>');
      $btn.attr('data-pkid', this.dataset.pkid).appendTo($col);
    });
    remove_fiids = [];
    frm.fiids.value = '';

    $body.addClass('d-none');
    $popin.prependTo($msg).removeClass('d-none');
  });

  $('#message-revert').on('click', function(event) {
    event.preventDefault();
    let $row = $(`#message-${frm.fmid.value}`);
    let $msg = $row.find('.message');
    let $body = $msg.find('.body');
    let $roll = $row.find('.message-roll');
    $popin.addClass('d-none');
    $body.removeClass('d-none');
    $roll.removeClass('d-none');
    // remove_fiids = [];
    // frm.fiids.value = '';
  });

  $('a.message-delete').on('click', function(event) {
    event.preventDefault();
    if (!confirm('Are you sure you want to delete this message?')) return;
    frm.fmid.value = this.dataset.key;
    $('#btnMessageDelete').click();
  });

  $('a.thread-edit').on('click', function(event) {
    event.preventDefault();
    $('#thread_subject').addClass('d-none');
    $('#edit_subject').removeClass('d-none');
  });

  $('#thread-revert').on('click', function(event) {
    event.preventDefault();
    $('#thread_subject').removeClass('d-none');
    $('#edit_subject').addClass('d-none');
  });

  $('a.thread-delete').on('click', function(event) {
    event.preventDefault();
    if (!confirm('Are you sure you want to delete this thread?')) return;
    $('#btnThreadDelete').click();
  });

  $('#edit_roll').on('click', '.btn-delete-img', function() {
    remove_fiids.push(this.dataset.pkid);
    frm.fiids.value = remove_fiids.join(',');
    $(this).parent().find('img').animate({ height: 0, opacity: 0 }, 400, ()=>{ $(this).parent().remove() });
  });
});
