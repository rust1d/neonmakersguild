<cfoutput>
  <cfif session.user.admin() && locals.mBE.promotable()>
    <cfif locals.mBE.is_promoted()>
      <button name='btnPromote' data-pkid='#locals.mBE.encoded_key()#' class='btn btn-icon btn-icon-sm active top-right' title='Click to remove from front page'>
        <i class='fa-solid fa-star'></i>
      </button>
    <cfelse>
      <button name='btnPromote' data-pkid='#locals.mBE.encoded_key()#' class='btn btn-icon btn-icon-sm btn-nmg top-right' title='Click to promote to front page'>
        <i class='fa-solid fa-fw fa-star' title='Front Page #locals.mBE.promoted()#'></i>
      </button>
    </cfif>
  <cfelseif isDate(locals.mBE.ben_promoted())>
    <sup><i class='ms-1 fa-solid fa-fw fa-star text-warning' title='Front Page #locals.mBE.promoted()#'></i></sup>
  </cfif>
</cfoutput>
