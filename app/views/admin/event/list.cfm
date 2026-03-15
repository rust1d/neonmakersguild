<cfscript>
  mdl = new app.models.Events();
  mEvents = mdl.where(utility.paged_term_params());
  pagination = mdl.pagination();
</cfscript>

<cfoutput>
  <div class='card'>
    <div class='card-header bg-nmg'>
      <div class='row align-items-center'>
        <div class='col fs-5'>Events</div>
        <div class='col-auto'>
          <a href='#router.href('event/edit')#' class='btn btn-sm btn-nmg' title='Add'>
            <i class='fa-solid fa-fw fa-plus'></i>
          </a>
        </div>
        #router.include('shared/partials/filter_and_page', { pagination: pagination, placeholder: 'search events...' })#
      </div>
    </div>
    <div class='card-body table-responsive'>
      <table class='table table-sm table-nmg'>
        <thead>
          <tr>
            <th scope='col'>
              <a href='#router.href('event/edit')#' class='btn btn-sm btn-nmg'><i class='fa-solid fa-fw fa-plus'></i></a>
            </th>
            <th scope='col'>Summary</th>
            <th scope='col'>Location</th>
            <th scope='col'>Start</th>
            <th scope='col'>All Day</th>
            <th scope='col'>Created By</th>
          </tr>
        </thead>
        <tbody>
          <cfloop array='#mEvents#' item='mEvent'>
            <tr>
              <th scope='row'>
                <a href='#router.hrefenc(page: "event/edit", evid: mEvent.evid())#' class='btn btn-sm btn-nmg'>
                  <i class='fa-solid fa-fw fa-pencil'></i>
                </a>
              </th>
              <td>#encodeForHTML(mEvent.summary())#</td>
              <td>#encodeForHTML(mEvent.location())#</td>
              <td>
                #dateFormat(mEvent.start(), 'mmm dd, yyyy')#
                <cfif !mEvent.allday()> #timeFormat(mEvent.start(), 'h:nn tt')#</cfif>
              </td>
              <td>#mEvent.allday() ? 'Yes' : ''#</td>
              <td>#mEvent.User().user()#</td>
            </tr>
          </cfloop>
        </tbody>
      </table>
      <cfif pagination.total gt pagination.page_size>
        <div class='row justify-content-end'>
          #router.include('shared/partials/filter_and_page', { pagination: pagination, footer: true })#
        </div>
      </cfif>
    </div>
  </div>
</cfoutput>
