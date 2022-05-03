$(function() {
  let frm = $('#edit_message')[0].form;

  $('a.message-edit').on('click', function(event) {
    event.preventDefault();
    var $div = $('#message-' + this.dataset.key);
    $div.find('.message').hide();
    tinymce.get("edit_message").destroy();
    $('#edit_popin').appendTo($div).removeClass('d-none');
    frm.edit_message.value = $div.find('.message').text();
    init_tinyforum(frm.edit_message);
    frm.fmid.value = this.dataset.key;
  });

  $('#message-revert').on('click', function(event) {
    event.preventDefault();
    var $div = $('#message-' + frm.fmid.value);
    $div.find('.message').show();
    $('#edit_popin').addClass('d-none');
  });
});
