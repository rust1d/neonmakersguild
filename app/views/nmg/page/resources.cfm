<cfscript>
  mLinks = mBlog.links();
</cfscript>

<cfoutput>
  <div class='card'>
    <h4 class='card-header'>Neon Material Suppliers</h4>
    <div class='card-body'>
      <div class='row'>
        <div class='col-12'>
          <ul>
            <cfloop array='#mLinks.filter(row=>row.isSupplier())#' item='mLink'>
              <li class='mb-2'>
                <a class='fs-6' href='#mLink.url()#' data-link='#mLink.datadash()#' target='_blank'>#mLink.title()#</a>
                <cfif mLink.description().len()>
                  <div class='small'>#mLink.description()#</div>
                </cfif>
              </li>
            </cfloop>
          </ul>
        </div>
      </div>
    </div>
  </div>

  <div class='card mt-3'>
    <h4 class='card-header'>Neon Classes and Workshops</h4>
    <div class='card-body'>
      <div class='row'>
        <div class='col-12'>
          <ul>
            <cfloop array='#mLinks.filter(row=>row.isClass())#' item='mLink'>
              <li class='mb-2'>
                <a class='fs-6' href='#mLink.url()#' target='_blank'>#mLink.title()#</a>
                <cfif mLink.description().len()>
                  <div class='small'>#mLink.description()#</div>
                </cfif>
              </li>
            </cfloop>
          </ul>
        </div>
      </div>
    </div>
  </div>

</cfoutput>
