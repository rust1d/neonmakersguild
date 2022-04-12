component accessors=true {
  public Blog function init(required numeric blogid, Users user) {
    variables.mBlog = arguments.user ?: new app.models.Users().find(blogid);
    variables.utility = application.utility;
    return this;
  }

  public BlogCategories function category_build(required struct params) {
    params.append({ bca_blog: id() });
    return new app.models.BlogCategories(params);
  }

  public BlogCategories function category_by_alias(required string alias) {
    var mdl = new app.models.BlogCategories();
    var matches = mdl.where(bca_alias: alias);
    if (matches.len()) return matches.first();
    return mdl.set({
      bca_blog: id(),
      bca_alias: alias,
      bca_category: 'Category Not Found'
    });
  }

  public BlogCategories function category_find_or_create(required numeric pkid) {
    var mdl = new app.models.BlogCategories();
    try { return mdl.find(pkid) } catch (record_not_found err) { return mdl.set({ bca_blog: id() }) }
  }

  public query function category_search(struct params) {
    if (arguments.keyExists('params')) arguments = arguments.params;
    arguments.bca_blog = id();
    return new app.models.BlogCategories().search(arguments);
  }

  public boolean function category_save(required BlogCategories mCategory) {
    if (mCategory.new_record() && !isAuthorized('AddCategory')) return application.flash.error('Sorry you are not authorized to add categories.');
    var matches = mCategory.where(bca_blog: id(), bca_category: mCategory.category());
    if (matches.len()==1 && (mCategory.new_record() || matches[1].bcaid()!=mCategory.bcaid())) return application.flash.error('Category exists.');
    if (matches.len()>1) return application.flash.error('blog.category_save too many rows.');
    return mCategory.safe_save();
  }

  public BlogEntries function entry_by_alias(required string alias) {
    var mdl = new app.models.BlogEntries();
    var matches = mdl.where(ben_alias: alias);
    if (matches.len()) return matches.first();
    return mdl.set({
      ben_blog: id(),
      ben_alias: alias,
      ben_title: 'Entry Not Found'
    });
  }

  public BlogEntries function entry_find_or_create(required numeric pkid) {
    var mdl = new app.models.BlogEntries();
    try {
      return mdl.find(pkid)
    } catch (record_not_found err) {
      return mdl.set({
        ben_usid: session.user.usid(),
        ben_blog: id(),
        ben_released: isAuthorized('ReleaseEntries'),
        ben_posted: now()
      });
    }
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

  public string function name() {
    return mBlog.user();
  }

  public any function onMissingMethod(required string missingMethodName, required struct missingMethodArguments) {
    return invoke(variables.mBlog, missingMethodName, missingMethodArguments);
  }

  public BlogPages function page_by_alias(required string alias) {
    var mdl = new app.models.BlogPages();
    var matches = mdl.where(bpa_alias: alias);
    if (matches.len()) return matches.first();
    return mdl.set({
      bpa_blog: id(),
      bpa_alias: alias,
      bpa_title: 'Page Not Found'
    });
  }

  public BlogPages function page_find_or_create(required numeric pkid) {
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

  public numeric function unmoderated_count() {
    return new app.models.BlogComments().search(bco_blog: id(), bco_moderated: 0).len();
  }

  // PRIVATE

  public array function user_roles(required numeric usid) {
    return mBlog.BlogUserRoles(filter: { bur_usid: usid }).map(row => row.broid());
  }
}
