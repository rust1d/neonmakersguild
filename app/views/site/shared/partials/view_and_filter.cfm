<cfscript>
  locals.view = session.user.view();
  locals.filter = true;
</cfscript>

<cfoutput>
  <cfif locals.filter>
    <div class='col-auto'>
      <form method='post'>
        <div class='input-group input-group-sm'>
            <input type='text' class='form-control' name='term' placeholder='search...' aria-label='Search' required>
            <button class='btn btn-nmg btn-sm btn-outline-dark' type='submit'><i class='fa fa-search'></i></button>
        </div>
      </form>
    </div>
  </cfif>
  <div class='col-auto'>
    <form method='post'>
      <div class='btn-group' role='group'>
        <button type='#ifin(locals.view=='grid', 'button', 'submit')#' name='btnView' value='grid' class='btn btn-nmg btn-sm btn-outline-dark' #ifin(locals.view=='grid', 'disabled')#><i class='fad fa-th '></i></button>
        <button type='#ifin(locals.view!='grid', 'button', 'submit')#' name='btnView' value='list' class='btn btn-nmg btn-sm btn-outline-dark' #ifin(locals.view!='grid', 'disabled')#><i class='fad fa-list'></i></button>
      </div>
    </form>
  </div>
</cfoutput>