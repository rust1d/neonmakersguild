<cfscript>
  writedump(url);
  writedump(router.decode('benid'));

  mEntry = mBlog.entries(ben_benid: router.decode('benid')).first();
</cfscript>

<cfoutput>
  <div class='row'>
    <div class='col'>
      #router.include('shared/blog/entry', { mEntry: mEntry, fold: false })#
    </div>
  </div>
</cfoutput>
