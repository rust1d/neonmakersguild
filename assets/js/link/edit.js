get_social_name = function(url) {
  try {
    const host = new URL(url).hostname.replace(/^www\./, '').toLowerCase();
    return SERVER.socials[host] || '';
  } catch (err) {
    return '';
  }
}

update_from_url = function() {
  const name = get_social_name(this.value);
  if (name.length) {
    this.form.bli_title.value = name;
    this.form.bli_type.value = 'social media';
    this.form.bli_description.focus();
    $('#link_icon i').attr('class', `roundy mt-0 fa-lg fa-brands fa-${name.toLowerCase()}`);
  } else {
    this.form.bli_type.selectedIndex = 0;
    if (this.form.bli_type=='social media') return;
    update_from_type.call(this.form.bli_type);
  }
}

update_from_type = function() {
  let val = this.value;
  if (val=='social media') {
    update_from_url.call(this.form.bli_url);
  } else {
    const icon = SERVER.icons[this.value] || 'bookmark';
    $('#link_icon i').attr('class', `roundy mt-0 fa-lg ${icon}`);
  }
}

$(function() {
  $('#bli_url').on('change paste', debounce(update_from_url, 200));
  $('#bli_type').on('change', update_from_type);
});