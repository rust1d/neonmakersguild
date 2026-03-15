<cfscript>
  mEvents = new app.models.Events().where(ev_usid: mUser.usid());
  currentMonth = '';
</cfscript>

<cfoutput>
  <cfif session.user.isUser(mUser.usid())>
    <cfset router.include('shared/event/_form') />
    <div class='col-12 d-flex justify-content-between align-items-center'>
      <div class='small text-muted'>Events you add here are automatically posted to the <a href='/page/calendar'>NMG Calendar</a>.</div>
      <button class='btn btn-nmg rounded-pill px-4' data-bs-toggle='offcanvas' data-bs-target='##addEventDrawer'>
        <i class='fa-solid fa-calendar-plus me-2'></i>Add an Event
      </button>
    </div>
  </cfif>

  <cfif mEvents.len()>
    <cfloop array='#mEvents#' item='mEvent'>
      <cfif mEvent.month_key() != currentMonth>
        <cfset currentMonth = mEvent.month_key() />
        <div class='col-12 text-marker fs-5 mt-2'>#mEvent.month_label()#</div>
      </cfif>
      #router.include('shared/event/_card', { mEvent: mEvent, editable: session.user.isUser(mUser.usid()) })#
    </cfloop>
  <cfelse>
    <div class='col-12 content-card text-center text-muted p-4'>
      No events yet.
    </div>
  </cfif>
</cfoutput>
