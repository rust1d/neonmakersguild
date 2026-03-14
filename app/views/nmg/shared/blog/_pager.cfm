<cfoutput>
  <cfif !locals.pagination.one_page>
    <div class='col-12 d-flex justify-content-center align-items-center gap-3 mt-2 font-montserrat small'>
      <cfif locals.pagination.first>
        <span class='btn btn-sm btn-outline-secondary disabled'><i class='fa-solid fa-fw fa-caret-left'></i> Newer</span>
      <cfelse>
        <a href='#utility.page_url_prev(locals.pagination)#' class='btn btn-sm btn-nmg'><i class='fa-solid fa-fw fa-caret-left'></i> Newer</a>
      </cfif>
      <span class='text-muted'>Page #locals.pagination.page# of #locals.pagination.pages#</span>
      <cfif locals.pagination.last>
        <span class='btn btn-sm btn-outline-secondary disabled'>Older <i class='fa-solid fa-fw fa-caret-right'></i></span>
      <cfelse>
        <a href='#utility.page_url_next(locals.pagination)#' class='btn btn-sm btn-nmg'>Older <i class='fa-solid fa-fw fa-caret-right'></i></a>
      </cfif>
    </div>
  </cfif>
</cfoutput>
