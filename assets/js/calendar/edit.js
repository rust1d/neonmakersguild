$(function() {
  function toggleTimeFields() {
    var allDay = $('#ev_allday').is(':checked');
    $('.allday-field').toggle(allDay).find('input').prop('disabled', !allDay);
    $('.timed-field').toggle(!allDay).find('input, select').prop('disabled', allDay);
  }

  function resetForm() {
    $('#ev_evid').val('');
    $('#eventForm')[0].reset();
    $('#addEventDrawer .text-marker').html('<i class="fa-solid fa-calendar-plus me-2"></i>Add an Event');
    toggleTimeFields();
  }

  // allday: auto-fill end date from start date
  $('input[name="ev_ad_start"]').on('blur', function() {
    var endInput = $('input[name="ev_ad_end"]');
    if (!endInput.val()) endInput.val($(this).val());
  });

  // timed: auto-fill end date from start date
  $('.timed-field input[name="ev_start"]').on('blur', function() {
    var endDate = $('.timed-field input[name="ev_end"]');
    if (!endDate.val()) endDate.val($(this).val());
  });

  // timed: auto-fill end time = start time + 1 hour
  $('input[name="ev_start_time"]').on('blur', function() {
    var endTime = $('input[name="ev_end_time"]');
    if (!endTime.val() && $(this).val()) {
      var parts = $(this).val().split(':');
      var h = (parseInt(parts[0]) + 1) % 24;
      endTime.val(('0' + h).slice(-2) + ':' + parts[1]);
    }
  });

  $('.btn-edit-event').on('click', function() {
    var $btn = $(this);
    $('#ev_evid').val($btn.data('evid'));
    $('#ev_summary').val($btn.data('summary'));
    $('#ev_location').val($btn.data('location'));
    $('#ev_description').val($btn.data('description'));
    $('#ev_allday').prop('checked', $btn.data('allday') == 1);
    $('#ev_timezone').val($btn.data('timezone'));
    $('input[name="ev_ad_start"]').val($btn.data('start'));
    $('input[name="ev_ad_end"]').val($btn.data('end'));
    $('.timed-field input[name="ev_start"]').val($btn.data('start'));
    $('input[name="ev_start_time"]').val($btn.data('start-time'));
    $('.timed-field input[name="ev_end"]').val($btn.data('end'));
    $('input[name="ev_end_time"]').val($btn.data('end-time'));

    $('#addEventDrawer .text-marker').html('<i class="fa-solid fa-calendar-pen me-2"></i>Edit Event');
    toggleTimeFields();

    new bootstrap.Offcanvas('#addEventDrawer').show();
  });

  $('#addEventDrawer').on('hidden.bs.offcanvas', resetForm);
  $('#ev_allday').on('change', toggleTimeFields);

  toggleTimeFields();
});
