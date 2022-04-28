<cfscript>
  mEntries = mBlog.entries(ben_released: true, maxrows: 5);
</cfscript>

<cfoutput>
  <div class='row g-3'>
    <div class='col fs-2 text-center text-page-head'>Welcome to the Neon Makers Guild!</div>
    <cfloop array='#mEntries#' item='mEntry' index='idx'>
      <div class='col-12'>
        #router.include('shared/blog/entry', { mEntry: mEntry, fold: idx gt 3 })#
      </div>
    </cfloop>
  </div>
</cfoutput>
