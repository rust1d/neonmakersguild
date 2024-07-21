<cfscript>
  locals.view = session.user.view();
</cfscript>

<cfoutput>
  <div class='col-auto'>
    <form method='post'>
      <div class='btn-group' role='group'>
        <button type='#ifin(locals.view=='grid', 'button', 'submit')#' name='btnView' value='grid' class='btn btn-sm btn-nmg' #ifin(locals.view=='grid', 'disabled')#><i class='fa-solid fa-fw fa-th'></i></button>
        <button type='#ifin(locals.view!='grid', 'button', 'submit')#' name='btnView' value='list' class='btn btn-sm btn-nmg' #ifin(locals.view!='grid', 'disabled')#><i class='fa-solid fa-fw fa-list'></i></button>
      </div>
    </form>
  </div>
</cfoutput>
