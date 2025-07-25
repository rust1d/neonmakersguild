<cfscript>
  mMemberRequests = new app.models.MemberRequests().where(utility.paged_term_params());
  pagination = request.pagination.last;
</cfscript>

<cfoutput>
  <div class='card'>
    <div class='card-header bg-nmg'>
      <div class='row'>
        <div class='col fs-5'>Pending Member Requests</div>
        #router.include('shared/partials/filter_and_page', { pagination: pagination })#
      </div>
    </div>
    <div class='card-body'>
      <table class='table table-sm table-nmg'>
        <thead>
          <tr>
            <th scope='col'>&nbsp;</th>
            <th scope='col'>Name</th>
            <th scope='col'>Email</th>
            <th scope='col'>Validated</th>
            <th scope='col'>Accepted</th>
          </tr>
        </thead>
        <tbody>
          <cfloop array='#mMemberRequests#' item='mMR'>
            <tr>
              <th scope='row'>
                <a href='#router.hrefenc(page: 'requests/edit', mrid: mMR.mrid())#' class='btn btn-sm btn-nmg'>
                  <i class='fa-solid fa-fw fa-pencil'></i>
                </a>
              </th>
              <td>#mMR.firstname()# #mMR.lastname()#</td>
              <td>#mMR.email()#</td>
              <td><i class='fa-solid #ifin(mMR.email_validated(), 'fa-circle-dot', 'fa-circle')#'></i></td>
              <td><i class='fa-solid #ifin(mMR.accept_sent(), 'fa-circle-dot', 'fa-circle')#'></i></td>
            </tr>
          </cfloop>
        </tbody>
      </table>
    </div>
  </div>

  <div class='modal fade' id='helpModal' tabindex='-1' aria-labelledby='helpModalLabel' aria-hidden='true'>
    <div class='modal-dialog border-nmg border rounded modal-lg modal-dialog-scrollable'>
      <div class='modal-content bg-nmg'>
        <div class='modal-header'>
          <h5 class='modal-title' id='helpModalLabel'>Member Request Help</h5>
          <button type='button' class='btn-close' data-bs-dismiss='modal' aria-label='Close'></button>
        </div>
        <div class='modal-body'>
          <div class='container-fluid'>
            #router.include('shared/help/memberrequest')#
          </div>
        </div>
      </div>
    </div>
  </div>
</cfoutput>
