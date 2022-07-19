<cfscript>
  if (!session.user.admin() || router.decode('pkid')==0) router.redirect();

  mEntry = new app.models.BlogEntries().find(router.decode('pkid'));

  if (mEntry.promoted().len()) {
    mEntry.ben_promoted(javaCast('null',0));
    msg = 'Entry was removed from the front page.';
  } else {
    mEntry.ben_promoted(now());
    msg = 'Entry was promoted to the front page.';
  }

  if (mEntry.safe_save()) {
    flash.success(msg);
  }

  router.go(mEntry.seo_link());
</cfscript>