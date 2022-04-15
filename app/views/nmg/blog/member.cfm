<cfscript>
  mUser = new app.models.Users().find(router.decode('usid'));
  mEntries = mBlog.entries(ben_usid: router.decode('usid'), maxrows: 5);
</cfscript>

<cfoutput>
  <div class='row'>
    <div class='col'>
      #router.include('shared/user/view', { mUser: mUser })#

      <cfloop array='#mEntries#' item='mEntry' index='idx'>
        #router.include('shared/blog/entry', { mEntry: mEntry, fold: true })#
      </cfloop>
    </div>
  </div>
</cfoutput>
