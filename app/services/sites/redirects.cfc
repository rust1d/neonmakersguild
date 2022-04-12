component {
  public Redirects function init() {
    variables.router = new app.services.router('home', session.site.path());
    variables.utility = application.utility;
    return this;
  }

  public void function perform() {
    check_rewrites();
  }

  public void function check_rewrites() {
    if (url.keyExists('seo')) rewrite_seo();
  }

  //

  private Blog function blog() {
    if (isNull(variables._blog)) {
      var mdl = new app.models.Users().where(us_user: url.blog);
      variables._blog = mdl.len() ? mdl.first().blog() : new app.services.user.Blog(1);
    }
    return variables._blog;
  }

  private void function rewrite_blog() {
    if (url.keyExists('category')) {
      var mdl = blog().category_by_alias(url.category);
      if (mdl.new_record()) return;
      url.p = url.keyExists('entry') ? 'blog/category_entry' : 'blog/category_page';
      url.bcaid = mdl.encoded_key();
    } else if (url.keyExists('entry')) {
      var mdl = blog().entry_by_alias(url.entry);
      if (mdl.new_record()) return;
      url.p = 'blog/entry';
      url.benid = mdl.encoded_key();
    } else if (url.keyExists('page')) {
      var mdl = blog().page_by_alias(url.page);
      if (mdl.new_record()) return;
      url.p = 'blog/page';
      url.bpaid = mdl.encoded_key();
    }
  }

  private void function rewrite_seo() {
    url.delete('seo');
    url.p = 'blog/page'; // default to page for 404
    if (url.keyExists('blog')) {
      return rewrite_blog();
    } else if (url.keyExists('user')) {
      var qry = new app.models.Users().search(us_user: url.user);
      if (qry.len()) {
        url.p = 'blog/member';
        url.usid = router.encode(id: qry.us_usid).listLast('=');
      }
    }
  }
}
