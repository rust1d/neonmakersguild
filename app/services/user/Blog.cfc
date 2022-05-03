component accessors=true {
  public Blog function init(required numeric blogid, Users user) {
    variables.mBlog = arguments.user ?: new app.models.Users().find(blogid);
    variables.utility = application.utility;
    return this;
  }

  public array function categories(struct params) {
    if (arguments.keyExists('params')) arguments = arguments.params;
    var args = { bca_blog: id(), maxrows: 100 }
    args.append(arguments);
    return new app.models.BlogCategories().where(args);
  }

  public BlogCategories function category_build(required struct params) {
    params.append({ bca_blog: id() });
    return new app.models.BlogCategories(params);
  }

  public BlogCategories function category_by_alias(required string alias) {
    var mdl = new app.models.BlogCategories();
    var matches = mdl.where(bca_blog: id(), bca_alias: alias);
    if (matches.len()) return matches.first();
    return mdl.set({
      bca_blog: id(),
      bca_alias: alias,
      bca_category: 'Category Not Found'
    });
  }

  public BlogCategories function category_find_or_create(required numeric pkid) {
    var mdl = new app.models.BlogCategories();
    if (pkid==0) return mdl.set({ bca_blog: id() });

    var matches = mdl.where(bca_bcaid: pkid, bca_blog: id());
    if (matches.len()) return matches.first();
    request.router.redirect();
  }

  public query function category_search(struct params) {
    if (arguments.keyExists('params')) arguments = arguments.params;
    arguments.bca_blog = id();
    return new app.models.BlogCategories().search(arguments);
  }

  public boolean function category_save(required BlogCategories mCategory) {
    var matches = mCategory.where(bca_blog: id(), bca_category: mCategory.category());
    if (matches.len()==1 && (mCategory.new_record() || matches[1].bcaid()!=mCategory.bcaid())) return application.flash.error('Category exists.');
    if (matches.len()>1) return application.flash.error('blog.category_save too many rows.');
    return mCategory.safe_save();
  }

  public BlogEntries function entry_by_alias(required string alias) {
    var mdl = new app.models.BlogEntries();
    var matches = mdl.where(ben_blog: id(), ben_alias: alias);
    if (matches.len()) return matches.first();
    return mdl.set({
      ben_blog: id(),
      ben_alias: alias,
      ben_title: 'Entry Not Found'
    });
  }

  public BlogEntries function entry_find_or_create(required numeric pkid) {
    var mdl = new app.models.BlogEntries();
    if (pkid==0) return mdl.set({
      ben_usid: session.user.usid(),
      ben_blog: id(),
      ben_released: true,
      ben_comments: true,
      ben_image: '/assets/images/1200x600.png',
      ben_posted: now()
    });

    var matches = mdl.where(ben_benid: pkid, ben_blog: id());
    if (matches.len()) return matches.first();
    request.router.redirect();
  }

  public array function entries(struct params) {
    if (arguments.keyExists('params')) arguments = arguments.params;
    var args = { ben_blog: id(), maxrows: 25 }
    args.append(arguments);
    return new app.models.BlogEntries().where(args);
  }

  public UserImages function image_find_or_create(required numeric pkid) {
    var mdl = new app.models.UserImages();
    try { return mdl.find(pkid) } catch (record_not_found err) { return mdl.set({ ui_usid: id() }) }
  }

  public array function images(struct params) {
    if (arguments.keyExists('params')) arguments = arguments.params;
    var args = { ui_usid: id(), maxrows: 25 }
    args.append(arguments);
    return new app.models.UserImages().where(args);
  }

  public string function getProperty(required string prop) {
    var props = {
      'moderate':   true,
      'settings':   true,
      'filebrowse': true
    }
    return props.get(prop);
  }

  public numeric function id() {
    return mBlog.usid();
  }

  public boolean function isAuthorized(required string role) {
    variables.roles = {
      admin: 1,
      pageadmin: 2,
      manageusers: 3,
      managecategories: 4,
      addcategory: 5,
      releaseentries: 6
    }
    var roles = user_roles(session.user.get_pkid());
    return roles.find(variables.roles[role]) || roles.find(variables.roles['admin']);
  }

  public BlogLinks function link_find_or_create(required numeric pkid) {
    var mdl = new app.models.BlogLinks();
    if (pkid==0) return mdl.set({ bli_blog: id() });

    var matches = mdl.where(bli_bliid: pkid, bli_blog: id());
    if (matches.len()) return matches.first();
    request.router.redirect();
  }

  public struct function links(struct params) {
    if (arguments.keyExists('params')) arguments = arguments.params;
    var args = { bli_blog: id(), maxrows: 25 }
    args.append(arguments);
    var mdl = new app.models.BlogLinks();
    var data['rows'] = mdl.where(args);
    data['pagination'] = mdl.pagination();
    return data;
  }

  public string function name() {
    return mBlog.user();
  }

  public any function onMissingMethod(required string missingMethodName, required struct missingMethodArguments) {
    return invoke(variables.mBlog, missingMethodName, missingMethodArguments);
  }

  public BlogPages function page_by_alias(required string alias) {
    var mdl = new app.models.BlogPages();
    var matches = mdl.where(bpa_blog: id(), bpa_alias: alias);
    if (matches.len()) return matches.first();
    return mdl.set({
      bpa_blog: id(),
      bpa_alias: alias,
      bpa_title: 'Page Not Found'
    });
  }

  public Users function owner() {
    return variables.mBlog;
  }

  public BlogPages function page_find_or_create(required numeric pkid) {
    var mdl = new app.models.BlogPages();
    if (pkid==0) return mdl.set({ bpa_blog: id() });

    var matches = mdl.where(bpa_bpaid: pkid, bpa_blog: id());
    if (matches.len()) return matches.first();
    request.router.redirect();


    var mdl = new app.models.BlogPages();
    try {
      return mdl.find(pkid);
    } catch (record_not_found err) {
      return mdl.set({ bpa_blog: id() });
    }
  }

  public string function page_seo_link(required string alias) {
    var mdl = page_by_alias(alias);
    return (mdl.new_record()) ? 'page/404' : mdl.seo_link();
  }

  public array function pages(struct params) {
    if (arguments.keyExists('params')) arguments = arguments.params;
    var args = { bpa_blog: id(), maxrows: 25 }
    args.append(arguments);
    return new app.models.BlogPages().where(args);
  }

  public BlogTextBlocks function textblock_find_or_create(required numeric pkid) {
    var mdl = new app.models.BlogTextBlocks();
    try {
      return mdl.find(pkid);
    } catch (record_not_found err) {
      return mdl.set({ btb_blog: id() });
    }
  }

  public BlogTextBlocks function textblock_by_label(required string label) {
    var mdl = new app.models.BlogTextBlocks();
    var matches = mdl.where(btb_label: label);
    if (matches.len()) return matches.first();
    return mdl.set({
      btb_blog: id(),
      btb_label: label
    });
  }

  public array function textblocks(struct params) {
    if (arguments.keyExists('params')) arguments = arguments.params;
    var args = { btb_blog: id(), maxrows: 25 }
    args.append(arguments);
    return new app.models.BlogTextBlocks().where(args);
  }

  public numeric function unmoderated_count() {
    return new app.models.BlogComments().search(bco_blog: id(), bco_moderated: 0).len();
  }

  // PRIVATE

  public array function user_roles(required numeric usid) {
    return mBlog.BlogUserRoles(filter: { bur_usid: usid }).map(row => row.broid());
  }
}
