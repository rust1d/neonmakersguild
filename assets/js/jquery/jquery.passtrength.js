;(function($, window, document, undefined) {

  var pluginName = 'passtrength',
    defaults = {
      minChars: 6,
      passwordToggle: true,
      tooltip: true
    }

  function Plugin(element, options) {
    this.element = element;
    this.$elem = $(this.element);
    this.options = $.extend({}, defaults, options);
    this._defaults = defaults;
    this._name = pluginName;
    _this = this;
    this.init();
  }

  Plugin.prototype = {
    init: function() {
      var _this = this,
        meter = jQuery('<div/>', { class: 'passtrengthMeter' }),
        tooltip = jQuery('<div/>', { class: 'tooltip', text: 'Enter password.' });

      meter.insertAfter(this.element);
      $(this.element).appendTo(meter);

      if (this.options.tooltip) {
        tooltip.appendTo(meter);
        var tooltipWidth = tooltip.outerWidth() / 2;
        tooltip.css('margin-left', -tooltipWidth);
      }

      this.$elem.bind('keyup keydown', function() {
        value = $(this).val();
        _this.check(value);
      });

      if (this.options.passwordToggle) _this.togglePassword();
    },

    check: function(value) {
      var len = 0,
        upper = 0,
        lower = 0,
        number = 0,
        special = 1,
        reLower = new RegExp('[a-z]'),
        reUpper = new RegExp('[A-Z]'),
        reNumber = new RegExp('[0-9]'),
        reSpecial = new RegExp('([!,%,&,@,#,$,^,*,?,_,~,=,-])');

      if (value.length >= this.options.minChars) len = 1;
      if (value.match(reLower)) lower = 1;
      if (value.match(reUpper)) upper = 1;
      if (value.match(reNumber)) number = 1;
      if (value.match(reSpecial)) special = 1;

      this.addStatus(len, lower, upper, number, special);
    },

    addStatus: function(len, lower, upper, number, special) {
      var status = '',
        text = '',
        msg = '',
        total = len + lower + upper + number + special,
        meter = $(this.element).closest('.passtrengthMeter'),
        tooltip = meter.find('.tooltip');

      meter.attr('class', 'passtrengthMeter');

      if (total==5) status = 'valid';
      else if (total==4) status = 'very-strong';
      else if (total==3) status = 'strong';
      else if (total==2) status = 'medium';
      else status = 'weak';

      if (total==5) text = 'Valid!';
      //else if (special==0) text = 'Must include 1 special char';
      else if (number==0) text = 'Must include 1 numeric char';
      else if (upper==0) text = 'Must include 1 uppercase char';
      else if (lower==0) text = 'Must include 1 lowercase char';
      else text = 'Must be at least ' + this.options.minChars + ' chars';

      if (total!=5) msg = text;
      this.$elem[0].setCustomValidity(msg);

      meter.addClass(status);
      if (this.options.tooltip) {
        tooltip.text(text);
      }
    },

    togglePassword: function() {
      var buttonShow = jQuery('<span/>', {class: 'showPassword', html: '<i class="far fa-eye"></i>'}),
        input =  jQuery('<input/>', {type: 'text'}),
        passwordInput = this;

      buttonShow.appendTo($(this.element).closest('.passtrengthMeter'));
      input.appendTo($(this.element).closest('.passtrengthMeter')).hide();

      $(this.element).bind('keyup keydown', function() {
        input.val($(passwordInput.element).val());
      });

      input.bind('keyup keydown', function() {
        $(passwordInput.element).val(input.val());
        value = $(this).val();
        _this.check(value);
      });

      $(document).on('click', '.showPassword', function() {
        buttonShow.find('i').toggleClass('fa-eye');
        buttonShow.find('i').toggleClass('fa-eye-slash');
        input.toggle();
        $(passwordInput.element).toggle();
      });
    }
  }

  $.fn[pluginName] = function(options) {
    return this.each(function() {
      if (!$.data(this, 'plugin_' + pluginName)) {
        $.data(this, 'plugin_' + pluginName, new Plugin(this, options));
      }
    });
  }

})(jQuery, window, document);
