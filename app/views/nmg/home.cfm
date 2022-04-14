<cfscript>
  mEntries = mBlog.entries(maxrows: 5);
</cfscript>
<cfoutput>
  <section class='container'>
    <div class='row'>
      <div class='col fs-2 text-center'>Welcome to the Neon Makers Guild!</div>
    </div>
    <div class='row'>
      <div class='col-md-9 border-end'>
        <cfloop array='#mEntries#' item='mEntry' index='idx'>
          #router.include('shared/blog/entry', { mEntry: mEntry, fold: idx gt 3 })#
        </cfloop>
      </div>
      <div class='col-md-3 border-start'>
        #router.include('shared/sidebar')#
      </div>
    </div>
  </section>
</cfoutput>
