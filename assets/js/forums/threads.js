$(function() {
  $('#btnCancel').on('click', function() {
    $('div.message-field').slideUp();
  });

  $('#ft_subject').on('focus', function() {
    if (this.value.length==0) {
      $('div.message-field').slideDown();
    }
  });
});
