<cfscript>
  mBlocks = mBlog.textblocks(btb_label: 'sidebar-%').rows;
</cfscript>

<cfoutput>
  <div class='row g-3'>
    <cfloop array='#mBlocks#' item='mBlock'>
      <div class='col-12 text-center rounded p-1 bg-nmg-light'>
        #mBlock.body()#
      </div>
    </cfloop>
  </div>
</cfoutput>
