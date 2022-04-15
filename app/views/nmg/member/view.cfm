<cfscript>
  usid = router.decode('usid');
  if (!usid) router.redirect('member/list');

  mUser = new app.models.Users().find(usid);
  mEntries = mUser.blog().entries(ben_usid: mUser.usid(), maxrows: 5);
</cfscript>

<cfoutput>
  <div class='row'>
    <cfloop array='#mUser.Entries()#' item='mEntry' index='idx'>
      <div class='col-#ifin(idx==1, 12, 6)#'>
        #router.include('shared/blog/entry', { mEntry: mEntry, fold: true })#
      </div>
    </cfloop>
  </div>
</cfoutput>
