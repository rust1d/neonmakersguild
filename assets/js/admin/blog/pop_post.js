$(function () {
  const frm = $('#blogform')[0];

  $('#schedule').on('change', function() {
    $('#schedule_options').slideToggle();
  });

  $('#btnEditCaptions').on('click', function() {
    $('#modal_entry').hide_bs();
    $('#modal_captions').show_bs();
  });

  $('#btnSaveCaptions').on('click', function() {
    $('#modal_entry').show_bs();
    $('#modal_captions').hide_bs();
  });

  // SAVE TO LOCAL STORAGE?
  // $('#btnCancel').on('click', function() {
  //   if (!confirm('Are you sure you want to cancel this blog post?')) return;
  //   const rtn = this.dataset.list || 'blog/entry/list';
  //   window.location = `?p=${rtn}`;
  // });

  $('[data-sortable]').each(function() {
    new Sortable(this, {
      animation: 150,
      ghostClass: 'drop-ghost',
      draggable: '.roll-img'
    });
  });
});
