$(function () {
  $('#btnPreview').on('click', function() {
    var $frm = $('#blogform').clone();
    $frm[0].target = '_blank';
    $frm[0].action = '?p=blog/textblock/preview';
    $frm[0].btb_body.value = tinyMCE.get('btb_body').getContent();
    $frm.appendTo('body').submit();
    $frm.remove();
  });
});
