<cfscript>
  mEntries = mBlog.entries(bca_bcaid: router.decode('bcaid'), maxrows: 5);
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
        Side Bar Content

      </div>
    </div>
  </section>
</cfoutput>
