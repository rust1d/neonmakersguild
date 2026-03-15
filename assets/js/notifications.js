$(function() {
  var $toggle = $('#navNotifyToggle');
  var $dropdown = $('#navNotifyDropdown');

  if (!$toggle.length) return;

  $toggle.on('click', function(e) {
    e.preventDefault();
    e.stopPropagation();
    $dropdown.toggleClass('d-none');
  });

  $(document).on('click', function(e) {
    if (!$(e.target).closest('.nav-drop-wrap').length) {
      $dropdown.addClass('d-none');
    }
  });
});
