<cfscript>
  mEntries = mBlog.entries(ben_released: true, maxrows: 5);
</cfscript>

<cfoutput>
  <div class='row'>
    <div class='col fs-2 text-center text-page-head'>Welcome to the Neon Makers Guild!</div>
  </div>
  <div class='row'>
    <div class='col'>
      <cfloop array='#mEntries#' item='mEntry' index='idx'>
        #router.include('shared/blog/entry', { mEntry: mEntry, fold: idx gt 3 })#
      </cfloop>
    </div>
  </div>
</cfoutput>
