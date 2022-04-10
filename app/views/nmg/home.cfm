<cfscript>
  mEntries = mBlog.entries(maxrows: 5);
</cfscript>
<cfoutput>
  <section class='container'>
    <h2 class='my-4'>Welcome to the Neon Makers Guild!</h2>
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
