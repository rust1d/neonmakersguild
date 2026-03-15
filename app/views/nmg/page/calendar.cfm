<cfscript>
  param url.view = 'calendar';
  if (form.keyExists('btnView')) url.view = form.btnView;
  if (!listFind('calendar,list', url.view)) url.view = 'calendar';

  // auto-switch to list when searching
  if ((form.keyExists('term') && form.term.len()) || (url.keyExists('term') && url.term.len())) url.view = 'list';

  mdl = new app.models.Events();
  mEvents = mdl.where(utility.paged_term_params());
  pagination = mdl.pagination();
</cfscript>

<cfif session.user.loggedIn()>
  <cfset router.include('shared/event/_form') />
</cfif>

<cfoutput>
  <div class='content-card mb-3'>
    <div class='row g-2 justify-content-end align-items-center'>
      <cfif session.user.loggedIn()>
        <div class='col-auto me-auto'>
          <button class='btn btn-nmg rounded-pill px-4' data-bs-toggle='offcanvas' data-bs-target='##addEventDrawer'>
            <i class='fa-solid fa-calendar-plus me-2'></i>Add an Event
          </button>
        </div>
      </cfif>
      #router.include('shared/partials/filter_and_page', { pagination: pagination, placeholder: 'search events...' })#
      <div class='col-auto'>
        <form method='post'>
          <div class='btn-group' role='group'>
            <button type='#ifin(url.view=="calendar", "button", "submit")#' name='btnView' value='calendar' class='btn btn-sm btn-nmg' #ifin(url.view=="calendar", "disabled")# title='Calendar'><i class='fa-solid fa-fw fa-calendar'></i></button>
            <button type='#ifin(url.view=="list", "button", "submit")#' name='btnView' value='list' class='btn btn-sm btn-nmg' #ifin(url.view=="list", "disabled")# title='List'><i class='fa-solid fa-fw fa-list'></i></button>
          </div>
        </form>
      </div>
    </div>
  </div>

  <cfif url.view == 'calendar'>
    <div class='ratio ratio-16x9'>
      <iframe class='bg-nmg' src='https://calendar.google.com/calendar/embed?height=600&wkst=1&ctz=America%2FNew_York&showPrint=0&showTitle=0&showCalendars=0&showTz=0&showTabs=0&src=ZmlsZXNAbmVvbm1ha2Vyc2d1aWxkLm9yZw&src=ZW4udXNhI2hvbGlkYXlAZ3JvdXAudi5jYWxlbmRhci5nb29nbGUuY29t&color=%23ad1457&color=%23a79b8e'></iframe>
    </div>
  <cfelse>
    <cfset currentMonth = '' />
    <div class='row g-3'>
      <cfloop array='#mEvents#' item='mEvent'>
        <cfif mEvent.month_key() != currentMonth>
          <cfset currentMonth = mEvent.month_key() />
          <div class='col-12 text-marker fs-5 mt-2'>#mEvent.month_label()#</div>
        </cfif>
        #router.include('shared/event/_card', { mEvent: mEvent })#
      </cfloop>

      <cfif !mEvents.len()>
        <div class='col-12 content-card text-center text-muted p-4'>
          No events found.
        </div>
      </cfif>

      <div class='col-12'>
        <div class='row justify-content-end'>
          #router.include('shared/partials/filter_and_page', { pagination: pagination, footer: true })#
        </div>
      </div>
    </div>
  </cfif>
</cfoutput>
