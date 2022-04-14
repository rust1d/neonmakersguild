$(function () {
  $('#btnPreview').on('click', function() {
    var $frm = $('#blogform').clone();
    $frm[0].target = '_blank';
    $frm[0].action = '?p=blog/page/preview';
    $frm[0].bpa_body.value = tinyMCE.get('bpa_body').getContent();
    $frm.appendTo('body').submit();
    $frm.remove();
  });
});
