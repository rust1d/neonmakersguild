$(function() {
  SERVER = {};

  $('script[data-json]').each(function() {
    let key = this.dataset.json;
    let data = JSON.parse(this.textContent);
    let def = data.constructor === Array ? [] : {};
    let obj = (key=='server') ? SERVER : SERVER[key] = SERVER[key] || def;
    for (let key in data) if (key) obj[key] = data[key];
  });

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

  $('button[name=btnPage]').on('click', function() {
    var $pager = $('input[name=set_page]');
    var page = $pager.val();
    if (page > $pager.attr('max') ||  page < $pager.attr('min')) page = 1;
    var searchParams = new URLSearchParams(window.location.search);
    searchParams.set('page', page);
    window.location.search = searchParams.toString();
  });

  $('#btnDelete').on('click', function(event) {
    if (!confirm('Are you sure you want to delete this record?')) event.preventDefault();
  });

  $('button[data-confirm]').on('click', function(event) {
    var msg = this.dataset.confirm;
    if (msg.length==0) msg = 'Are you sure?';
    if (!confirm(msg)) event.preventDefault();
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

  debounce = function(func, wait, immediate) {
    let timeout;
    return function() {
      const context = this;
      const args = arguments;
      const later = function() {
        timeout = null;
        if (!immediate) func.apply(context, args);
      }
      const callNow = immediate && !timeout;
      clearTimeout(timeout);
      timeout = setTimeout(later, wait);
      if (callNow) func.apply(context, args);
    }
  }

  get_base64_ext = function(base64) {
    const match = base64.match(/^data:image\/([a-zA-Z0-9+]+);base64,/);
    const ext = match ? match[1].toLowerCase() : 'png';
    return ext === 'jpeg' ? 'jpg' : ext;
  }
});
