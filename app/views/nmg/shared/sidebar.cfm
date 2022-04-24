<cfscript>
  mBlocks = mBlog.textblocks(btb_label: 'sidebar-%');
</cfscript>

<cfoutput>
  <div class='row g-3'>
    <cfloop array='#mBlocks#' item='mBlock'>
      <div class='col-12'>
        #mBlock.body()#
      </div>
    </cfloop>
  </div>
</cfoutput>
