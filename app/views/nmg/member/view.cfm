<cfscript>
  string function morecols(numeric idx, numeric size) {
    if (idx==1) return 'col-12';
    if (size%2==0 && idx==2) return 'col-12';
    return 'col-6'
  }

  usid = router.decode('usid');
  if (!usid) router.redirect('member/list');

  mUser = new app.models.Users().find(usid);
  mProfile = mUser.UserProfile() ?: mUser.UserProfile(build: {});
  mEntries = new app.models.BlogEntries().where(ben_usid: mUser.usid(), maxrows: 5);
</cfscript>

<cfoutput>
  <div class='row g-3'>
    <cfif mEntries.len()>
      <cfloop array='#mEntries#' item='mEntry' index='idx'>
        <div class='#morecols(idx, mEntries.len())#'>
          #router.include('shared/blog/entry', { mEntry: mEntry, fold: true })#
        </div>
      </cfloop>
    <cfelse>
      <div class='col-12 text-center rounded p-3 bg-nmg-light'>
        <div class='fs-3'>#mUser.user()#</div>
        <div>#mProfile.name()#</div>
        <div>#mProfile.location()#</div>
      </div>
      <div class='col-12 p-3 border-nmg bg-nmg border rounded'>
        #mProfile.bio()#
      </div>
    </cfif>
  </div>
</cfoutput>
