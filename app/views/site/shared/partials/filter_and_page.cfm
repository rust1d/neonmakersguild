<cfscript>
  param locals.footer = false;
</cfscript>

<cfoutput>
  <cfif locals.keyExists('pagination')>
    <cfif locals.pagination.keyExists('term')>
      <div class='col-auto'>
        <button onclick='window.location=window.location.href' class='border btn-nmg border-nmg rounded p-1 small'>
          #locals.pagination.term# &nbsp; <i class='fas fa-times'></i>
        </button>
      </div>
    </cfif>
    <div class='col small'>
      <cfif locals.footer>
        <cfif locals.pagination.total gt locals.pagination.page_size>#locals.pagination.start# - #locals.pagination.end# of </cfif>
        #utility.plural_label(locals.pagination.total, 'record')#
      </cfif>
    </div>
    <cfif !locals.footer>
      <div class='col-auto'>
        <form method='post'>
          <div class='input-group input-group-sm'>
            <input type='text' class='form-control' id='term' name='term' placeholder='search...' maxlength='20' aria-label='Search' required />
            <button class='btn btn-sm btn-nmg' type='submit'><i class='fa fa-search'></i></button>
          </div>
        </form>
      </div>
    </cfif>

    <div class='col-auto'>
      <div class='input-group input-group-sm'>
        <cfif locals.pagination.first>
          <button class='btn btn-nmg' disabled><i class='fa-solid fa-xl fa-caret-left'></i></button>
        <cfelse>
          <a class='btn btn-nmg' href='#utility.page_url_prev(locals.pagination)#'><i class='fa-solid fa-xl fa-caret-left'></i></a>
        </cfif>
        <cfif locals.pagination.pages lt 3>
          <span class='input-group-text btn-nmg'>Page #locals.pagination.page# of #locals.pagination.pages#</span>
        <cfelse>
          <button class='btn btn-nmg dropdown-toggle' type='button' data-bs-toggle='dropdown' aria-expanded='false'>Page #locals.pagination.page# of #locals.pagination.pages#</button>
          <ul class='dropdown-menu dropdown-menu-end bg-light'>
            <li>
              <div class='dropdown-item'>
                <div class='input-group input-group-sm pager'>
                  <button class='btn btn-nmg' type='button' name='btnPage'>Go to page</button>
                  <input type='number' class='form-control' name='set_page' min='1' max='#locals.pagination.pages#' value='#locals.pagination.page#' />
                </div>
              </div>
            </li>
          </ul>
        </cfif>
        <cfif locals.pagination.last>
          <button class='btn btn-nmg' disabled><i class='fa-solid fa-xl fa-caret-right'></i></button>
        <cfelse>
          <a class='btn btn-nmg' href='#utility.page_url_next(locals.pagination)#'><i class='fa-solid fa-xl fa-caret-right'></i></a>
        </cfif>
      </div>
    </div>
  </cfif>
</cfoutput>
