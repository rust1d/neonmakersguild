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

  $('#btnAddCategory').on('click', function() {
    var $cat = $('#bca_category');
    var data = $cat.val().trim();
    $cat.val('');
    if (!data.length) return $cat.focus();
    var matches = $("#ben_categories").find('option').filter((row,obj) => obj.text.localeCompare(data)==0);
    if (matches.length) {
      matches[0].selected = true;
      $cat.val('');
      return;
    }
    $("#ben_categories").prepend(`<option value='${data}' selected>${data}</option>`);
  });
});
