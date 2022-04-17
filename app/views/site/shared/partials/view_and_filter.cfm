<cfscript>
  locals.view = session.user.view();
  param locals.filter = true;
  param locals.viewer = true;
</cfscript>

<cfoutput>
  <cfif locals.filter>
    <div class='col-auto'>
      <form method='post'>
        <div class='input-group input-group-sm'>
          <input type='text' class='form-control' name='term' placeholder='search...' aria-label='Search' required />
          <button class='btn btn-sm btn-nmg' type='submit'><i class='fa fa-search'></i></button>
        </div>
      </form>
    </div>
  </cfif>
  <cfif locals.viewer>
    <div class='col-auto'>
      <form method='post'>
        <div class='btn-group' role='group'>
          <button type='#ifin(locals.view=='grid', 'button', 'submit')#' name='btnView' value='grid' class='btn btn-sm btn-nmg' #ifin(locals.view=='grid', 'disabled')#><i class='fad fa-th '></i></button>
          <button type='#ifin(locals.view!='grid', 'button', 'submit')#' name='btnView' value='list' class='btn btn-sm btn-nmg' #ifin(locals.view!='grid', 'disabled')#><i class='fad fa-list'></i></button>
        </div>
      </form>
    </div>
  </cfif>
</cfoutput>