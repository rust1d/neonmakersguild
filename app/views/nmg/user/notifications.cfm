<cfscript>
  if (form.keyExists('btnMarkRead') || url.keyExists('markread')) {
    new app.models.UserNotifications().mark_all_read(session.user.usid());
    flash.success('All notifications marked as read.');
    router.reload();
  }

  mdl = new app.models.UserNotifications();
  mNotifications = mdl.where(utility.paged_term_params({ un_usid: session.user.usid() }));
  pagination = mdl.pagination();
</cfscript>

<cfoutput>
  <div class='row g-3'>
    <div class='col-12 text-center content-card bg-nmg-dark text-white py-4'>
      <div class='fs-2 text-marker'>Notifications</div>
    </div>
    <cfif mNotifications.len()>
      <div class='col-12 content-card'>
        <div class='row g-2 justify-content-end align-items-center'>
          <div class='col-auto'>
            <form method='post'>
              <button type='submit' name='btnMarkRead' class='btn btn-sm btn-outline-nmg rounded-pill px-3'>
                <i class='fa-solid fa-check-double me-1'></i>Mark All Read
              </button>
            </form>
          </div>
        </div>
      </div>
    </cfif>

    <cfif mNotifications.len()>
      <cfloop array='#mNotifications#' item='mNote'>
        <div class='col-12 content-card #ifin(!mNote.read(), "border-start border-3 border-nmg")#'>
          <div class='d-flex align-items-start gap-3'>
            <cfif mNote.from_usid()>
              <img class='avatar-circle flex-shrink-0' style='width:36px;min-width:36px' src='#new app.models.Users().find(mNote.from_usid()).profile_image().src()#' />
            <cfelse>
              <div class='flex-shrink-0 text-center' style='width:36px'>
                <i class='fa-solid fa-bell fa-lg text-nmg'></i>
              </div>
            </cfif>
            <div class='flex-grow-1'>
              <cfif mNote.link().len()>
                <a href='#mNote.link()#' class='text-decoration-none fw-semibold'>#encodeForHTML(mNote.message())#</a>
              <cfelse>
                <div class='fw-semibold'>#encodeForHTML(mNote.message())#</div>
              </cfif>
              <div class='smallest text-muted'>#utility.age_format(mNote.added())#</div>
            </div>
            <cfif !mNote.read()>
              <span class='badge bg-nmg smallest'>new</span>
            </cfif>
          </div>
        </div>
      </cfloop>

      <div class='col-12'>
        <div class='row justify-content-end'>
          #router.include('shared/partials/filter_and_page', { pagination: pagination, footer: true })#
        </div>
      </div>
    <cfelse>
      <div class='col-12 content-card text-center text-muted p-4'>
        No notifications.
      </div>
    </cfif>
  </div>
</cfoutput>
