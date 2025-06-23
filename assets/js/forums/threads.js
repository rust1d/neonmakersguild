$(function() {
  // $('#ft_subject').on('blur', function() {
  //   if (this.value.length==0) {
  //     $('div.message-field').slideUp();
  //   }
  // });

  $('#ft_subject').on('focus', function() {
    if (this.value.length==0) {
      $('div.message-field').slideDown();
    }
  });
});
