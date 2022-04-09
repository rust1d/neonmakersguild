<cfscript>
  mUser = new app.models.Users().find(router.decode('usid'));
  mProfile = mUser.UserProfile() ?: mUser.UserProfile(build: {});
  mEntries = mBlog.entries(ben_usid: router.decode('usid'), maxrows: 5);
</cfscript>
<cfoutput>
  <section class='container'>
    <div class='row'>
      <div class='col-md-9 border-end'>
        <cfloop array='#mEntries#' item='mEntry' index='idx'>
          #router.include('shared/blog/entry', { mEntry: mEntry, fold: true })#
        </cfloop>
      </div>
      <div class='col-md-3 border-start'>
        #router.include('shared/user/view', { mUser: mUser })#
      </div>
    </div>
  </section>
</cfoutput>
