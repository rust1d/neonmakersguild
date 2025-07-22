$(function () {
  const frm = $('#blogform')[0];

  $('#post_modal').on('shown.bs.modal', function () {
    $('#ben_title').trigger('focus');
  });

  $('#ben_schedule').on('change', function() {
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

  $('[data-sortable]').each(function() {
    new Sortable(this, {
      animation: 150,
      ghostClass: 'drop-ghost',
      draggable: '.roll-img'
    });
  });
});
