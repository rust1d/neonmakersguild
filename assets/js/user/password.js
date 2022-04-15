$(function() {
  validatePassword = function(frm) {
    var pwd = frm.password.value;
    var pwd2 = frm.passagain.value;

    if (pwd.length==0) return;

    if (pwd2.length==0) {
      frm.passagain.setCustomValidity('Please fill out this field');
    } else if (pwd!=pwd2) {
      frm.passagain.setCustomValidity('Passwords do not match.');
    }
  }

  $('#password').passtrength();

  $('#btnSave').on('click', function() {
    if ($('#password').is(":hidden")) $('.showPassword').trigger('click');
    var frm = this.form;
    validatePassword(frm);

    if (!frm.checkValidity()) {
      frm.reportValidity();
      return;
    }
    frm.submit();
  });
});
