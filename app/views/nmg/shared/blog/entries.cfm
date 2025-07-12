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

  <cfif !locals.results.pagination.one_page>
    <div class='col-4 text-center text-uppercase'>
      <cfif !locals.results.pagination.first>
        <a href='#utility.page_url_prev(locals.results.pagination)#'><i class='fa-solid fa-fw fa-xl fa-caret-left'></i> Newer Posts</a>
      </cfif>
    </div>
    <div class='col-4 text-center text-uppercase'>
      Page #locals.results.pagination.page# of #locals.results.pagination.pages#
    </div>
    <div class='col-4 text-center text-uppercase'>
      <cfif !locals.results.pagination.last>
        <a href='#utility.page_url_next(locals.results.pagination)#'>Older posts <i class='fa-solid fa-fw fa-xl fa-caret-right'></i></a>
      </cfif>
    </div>
  </cfif>
</cfoutput>
