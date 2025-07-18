$(function() {
  $('a.comment-edit').on('click', function(event) {
    event.preventDefault();
    var $div = $('#comment-' + this.dataset.key);
    $div.find('.comment-body').hide();
    $('#edit_popin').detach().appendTo($div).removeClass('d-none');
    var frm = $('#edit_comment')[0].form;
    frm.edit_comment.value = $div.find('.comment-body').text();
    frm.bcoid.value = this.dataset.key;
  });

  $('#comment-revert').on('click', function(event) {
    event.preventDefault();
    var frm = $('#edit_comment')[0].form;
    var $div = $('#comment-' + frm.bcoid.value);
    $div.find('.comment-body').show();
    $('#edit_popin').addClass('d-none');
  });
});
