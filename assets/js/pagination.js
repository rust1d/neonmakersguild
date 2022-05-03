$(function () {
  $('div.search-pagination').on('change', 'select[name=change_size]', function() {
    this.form.pagesize.value = $(this).val();
    this.form.submit();
  });

  $('div.search-pagination').on('click', 'button[name=change_page]', function() {
    this.form.page.value = $(this).data('page');
    this.form.submit();
  });

  $('div.search-pagination').on('click', 'button[name=change_view]', function() {
    this.form.view.value = $(this).data('view');
    this.form.submit();
  });
});
