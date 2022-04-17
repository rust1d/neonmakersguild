<cfscript>
  string function morecols(numeric idx, numeric size) {
    if (idx==1) return 'col-12';
    if (size%2==0 && idx==2) return 'col-12';
    return 'col-6'
  }

  usid = router.decode('usid');
  if (!usid) router.redirect('member/list');

  mUser = new app.models.Users().find(usid);
  mEntries = new app.models.BlogEntries().where(ben_usid: mUser.usid(), maxrows: 5);
</cfscript>

<cfoutput>
  <div class='row'>
    <cfloop array='#mEntries#' item='mEntry' index='idx'>
      <div class='#morecols(idx, mEntries.len())#'>
        #router.include('shared/blog/entry', { mEntry: mEntry, fold: true })#
      </div>
    </cfloop>
  </div>
</cfoutput>
