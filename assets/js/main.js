$(function() {
  $('body').on('click', '.clipable', function() {
    navigator.clipboard.writeText($(this).data('clip'));
    var el = $(this).addClass('clipped');
    setTimeout(() => { el.removeClass('clipped') }, 250);
  });

  $('a[data-link]').on('click', function() {
    if (this.dataset.link) {
      $.post({
        url: '/xhr.cfm?p=actions/link',
        cache: false,
        data: this.dataset.link,
        dataType: 'json',
        contentType: false,
        processData: false,
        error: function(err) { console.log(err) },
        success: function(data) { console.log(data) }
      });
    }
  });

  $('#btnDelete').on('click', function(event) {
    if (!confirm('Are you sure you want to delete this record?')) event.preventDefault();
  });

  postButton = function(btn) {
    // ANY input/button WITH onclick=postButton(this) WILL CREATE AND SUBMIT AN EMPTY FORM WITH JUST THE BUTTON NAME/VALUE
    var $frm = $(`<form method=post><input type=hidden name=${btn.name} value=${btn.value} /></form>`);
    $frm.appendTo('body').submit();
  }

  uri_to_blob = function(uri) {
    const parts = uri.split(',');
    const mime = parts[0].split(':')[1].split(';')[0];
    const binary = atob(parts[1]);
    var data = [];
    for (var i=0; i<binary.length; i++) data.push(binary.charCodeAt(i));
    return new Blob([new Uint8Array(data)], { type: mime });
  }

  slugger = function(txt) {
    return txt.toLowerCase().replace(/[^\w ]+/g, '').replace(/ +/g, '-');
  }

});
