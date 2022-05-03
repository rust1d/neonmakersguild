// ADD 'needs-validation' TO <form> TO VALIDATE IT

(function() {
  'use strict';
  window.addEventListener('load', function() {
    var forms = document.getElementsByClassName('needs-validation');
    Array.prototype.filter.call(forms, function(form) {
      form.addEventListener('submit', function(event) {
        if (form.checkValidity() === false) {
          event.preventDefault();
          event.stopPropagation();
          var divsToHide = document.getElementsByClassName('hide-invalid');
          for (var i = 0; i < divsToHide.length; i++) {
            divsToHide[i].style.display = 'none';
          }
        }
        form.classList.add('was-validated');
      }, false);
    });
  }, false);
})();
