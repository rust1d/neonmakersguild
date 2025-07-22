<cfset include_js('assets/js/blog/modals.js') />

<cfoutput>
  <cfloop array='#locals.results.rows#' item='locals.mBE' index='locals.idx'>
    <div class='col-12 content-card'>
      #router.include('shared/blog/post', { mBE: locals.mBE, section: locals.section, comment_target: 'post' })#
    </div>
    <cfif locals.idx!=locals.results.rows.len()>
      <div class='col-12'>
        #nmg_divider()#
      </div>
    </cfif>
  </cfloop>

  #router.include('shared/blog/_pager', locals.results)#
</cfoutput>
