$(function () {
  lookup = function(request, response) {
    $.post({
      url: SERVER.root + '/app/services/tags/lookup.cfc?method=autocomplete',
      contentType: 'application/json',
      dataType: 'json',
      data: JSON.stringify({ tag: request.term }),
      success: function(data) { response(data.data.rows) }
    });
  }

  add_tag = function(id, val) {
    if (val.length >= 3) {
      var $tag = $(`span[data-id='${id}']`);
      if ($tag.length==0) $tag = `<span class='badge bg-nmg' data-id='${id}'><input type=hidden name=tagids value='${id}' /> ${val} <i data-role=remove class='fas fa-times'></i></span>`;
      $tagger.before($tag);
    }
    $tagger.val('');
  }

  picked = function(ev, ui) {
    add_tag(ui.item.id, ui.item.value);
    return false;
  }

  render = function(ul, item) {
    return $('<li>').append(item.label).appendTo(ul);
  }

  $tagger = $('#tagger');
  $tagger.autocomplete({ minLength: 1, source: lookup, select: picked, delay: 500, autoFocus: true });
  $tagger.autocomplete('instance')._renderItem=render;

  $('div.taglist').on('click', 'i', function() {
    this.parentElement.remove();
    $tagger.focus();
  });

  $tagger.on('keydown', function(event) {
    var $input = $(event.target);
    var text = $input.val().trim();
    if (event.which==13 || event.which==9) {
      if (event.which==13) event.preventDefault();
      add_tag(`"${text}"`, text);
    }
  });
});
