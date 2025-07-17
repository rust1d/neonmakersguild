(function($) {
  $.fn.notClass = function(className) {
    return !this.hasClass(className);
  };

  $.fn.show_bs = function() {
    return this.each(function() {
      $(this).removeClass('d-none');
    });
  };

  $.fn.hide_bs = function() {
    return this.each(function() {
      $(this).addClass('d-none');
    });
  };

  $.fn.toggle_bs = function(state) {
    return this.each(function() {
      if (typeof state === 'boolean') {
        $(this).toggleClass('d-none', !state);
      } else {
        $(this).toggleClass('d-none');
      }
    });
  };

  // THESE JUST REMOVE THE EXISTING 'd-none' CLASS USED TO HIDE THE ELEMENT ON PAGE LOAD. AFTER THAT jQ CAN USE style=
  $.fn.fadeOut_bs = function(duration, complete) {
    return this.each(function() {
      $(this).removeClass('d-none').fadeOut(duration, complete);
    });
  };

  $.fn.fadeIn_bs = function(duration, complete) {
    return this.each(function() {
    $(this).removeClass('d-none').fadeIn(duration, complete);
    });
  };

  $.fn.slideToggle_bs = function(duration, complete) {
    return this.each(function() {
      $(this).removeClass('d-none').slideToggle(duration, complete);
    });
  };
})(jQuery);
