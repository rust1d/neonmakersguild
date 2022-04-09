$(function () {
  $("#btnPreview").on('click', function() {
    var $frm = $('#blogform').clone();
    $frm[0].target = '_blank';
    $frm[0].action = '?p=blog/entry/preview';
    $frm.appendTo('body').submit();
    $frm.remove();
  });

  lookup = function(request, response) {
    $.post({
      url: 'xhr.cfm?p=blog/image/json',
      contentType: 'application/json',
      dataType: 'json',
      data: JSON.stringify({ term: request.term }),
      success: function(data) {
        // response(data.data);
        fill_select(data.data);
      }
    });
  }

  fill_select = function(rows) {
    var $sel = $('#imageselect');
    $sel.find('div').remove();
    for (var idx in rows) {
      var row = rows[idx];
      var htm = `<div class='col-3 p-1'><img class='w-100 img-thumbnail clipable' src=${row.thumbnail} data-clip=${row.image} title='${row.filename} - ${row.dimensions}' /></div>`
      $sel.append(htm);
    }
  }

  picked = function(event, ui) {
    this.value = ui.item.label;
    return false;
  }

  render = function(ul, item) {
    return $('<li>').attr('data-value', item.value).append(item.label).appendTo(ul);
  }

  $imagesearch = $('#imagesearch');
  $imagesearch.autocomplete({ minLength: 2, source: lookup, select: picked, delay: 500 });
  $imagesearch.autocomplete('instance')._renderItem=render;
});
