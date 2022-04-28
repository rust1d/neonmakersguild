<cfscript>
  param locals.page = 1;
  param locals.records = 0;
  locals.pages = max(1, ceiling(locals.records / 25));
</cfscript>

<cfoutput>
  <div class='col-auto'>
    <div class='input-group input-group-sm'>
      <button class='btn btn-nmg' type='button' #ifin(locals.pages==1, 'disabled')#><i class='fa-solid fa-caret-left'></i></button>
      <cfif locals.pages==1>
        <span class='input-group-text border-nmg bg-nmg'>Page #locals.page# of #locals.pages#</span>
      <cfelse>
        <button class='btn btn-nmg dropdown-toggle' type='button' data-bs-toggle='dropdown' aria-expanded='false'>Page #locals.page# of #locals.pages#</button>
        <ul class='dropdown-menu dropdown-menu-end bg-light'>
          <li>
            <div class='dropdown-item'>
              <div class='input-group input-group-sm pager'>
                <button class='btn btn-nmg' type='button' name='btnPage'>Go to page</button>
                <input type='number' class='form-control' name='set_page' min='1' max='#locals.pages#' value='#locals.page#' />
              </div>
            </div>
          </li>
        </ul>
      </cfif>
      <button class='btn btn-nmg' type='button' #ifin(locals.pages==1, 'disabled')#><i class='fa-solid fa-caret-right'></i></button>
    </div>
  </div>
</cfoutput>
