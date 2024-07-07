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
      url.blogid = variables._blog.id();
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
    } else if (url.keyExists('slug')) {
      var mdl = blog().page_by_alias(url.slug);
      if (mdl.new_record()) return;
      url.p = 'blog/page';
      url.bpaid = mdl.encoded_key();
    }
  }

  private void function rewrite_forum() {
    var qry = new app.models.Forums().search(fo_alias: url.forum);
    if (qry.len()==0) return;
    url.foid = qry.fo_foid;
    if (url.keyExists('ftid')) {
      qry = new app.models.ForumThreads().search(ft_ftid: url.ftid);
      if (qry.len()==0) return;
      url.ftid = qry.ft_ftid;
      url.p = 'forum/thread';
    } else {
      url.p = 'forum/threads'
    }
  }

  private void function rewrite_seo() {
    url.delete('seo');
    url.p = 'blog/page'; // default to page for 404
    if (url.keyExists('blog')) {
      return rewrite_blog();
    } else if (url.keyExists('forum')) {
      return rewrite_forum();
    } else if (url.keyExists('user')) {
      var qry = new app.models.Users().search(us_user: url.user);
      if (qry.len()) {
        url.p = 'member/view';
        url.tab = url.tab.lcase();
        url.usid = utility.encode(qry.us_usid);
        url.blogid = qry.us_usid;
      }
    }
  }
}
