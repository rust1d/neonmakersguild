<cfoutput>
  <cfif !locals.pagination.one_page>
    <div class='d-xs-block col-12 d-sm-none text-center small font-montserrat'>
      Page #locals.pagination.page# of #locals.pagination.pages#
    </div>
    <div class='col-6 col-sm-4 small text-center font-montserrat'>
      <cfif locals.pagination.first>
        <span class='text-muted'><i class='fa-solid fa-fw fa-caret-left'></i>Newer Posts</span>
      <cfelse>
        <a href='#utility.page_url_prev(locals.pagination)#'><i class='fa-solid fa-fw fa-caret-left'></i>Newer Posts</a>
      </cfif>
    </div>
    <div class='d-none d-sm-block col-sm-4 text-center small font-montserrat'>
      Page #locals.pagination.page# of #locals.pagination.pages#
    </div>
    <div class='col-6 col-sm-4 text-center  small font-montserrat'>
      <cfif locals.pagination.last>
        <span class='text-muted'><i class='fa-solid fa-fw fa-caret-right'></i>Older Posts</span>
      <cfelse>
        <a href='#utility.page_url_next(locals.pagination)#'>Older Posts<i class='fa-solid fa-fw fa-caret-right'></i></a>
      </cfif>
    </div>
  </cfif>
</cfoutput>
