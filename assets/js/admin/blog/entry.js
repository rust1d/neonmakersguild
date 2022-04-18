$(function () {
  $('#btnPreview').on('click', function() {
    var $frm = $('#blogform').clone();
    $frm[0].target = '_blank';
    $frm[0].action = '?p=blog/entry/preview';
    $frm[0].ben_body.value = tinyMCE.get('ben_body').getContent();
    $frm[0].ben_morebody.value = tinyMCE.get('ben_morebody').getContent();
    $frm.appendTo('body').submit();
    $frm.remove();
  });

  $('#btnCancel').on('click', function() {
    if (!confirm('Are you sure you want to cancel this entry?')) return;
    window.location = '?p=blog/entry/list';
  });
});
