<cfscript>
  param locals.editable = false;
</cfscript>

<cfoutput>
  <div class='col-12 content-card hover-lift'>
    <div class='d-flex align-items-start gap-3'>
      <div class='text-center flex-shrink-0' style='width:50px'>
        <div class='fs-4 fw-bold text-nmg lh-1'>#dateFormat(locals.mEvent.start(), 'dd')#</div>
        <div class='smallest text-uppercase text-muted'>#dateFormat(locals.mEvent.start(), 'mmm')#</div>
      </div>
      <div class='flex-grow-1'>
        <div class='fw-semibold'>#encodeForHTML(locals.mEvent.summary())#</div>
        <div class='small text-muted'>
          <i class='fa-solid fa-location-dot me-1'></i><cfif locals.mEvent.location().left(4) == 'http'><a href='#encodeForHTML(locals.mEvent.location())#' target='_blank'>#encodeForHTML(locals.mEvent.location())#</a><cfelse>#encodeForHTML(locals.mEvent.location())#</cfif>
        </div>
        <cfif locals.mEvent.allday()>
          <div class='small text-muted'>
            <i class='fa-regular fa-clock me-1'></i>All day
            <cfif isDate(locals.mEvent.end()) && locals.mEvent.start_date() != locals.mEvent.end_date()>
              &mdash; #dateFormat(locals.mEvent.end(), 'mmm dd, yyyy')#
            </cfif>
          </div>
        <cfelse>
          <div class='small text-muted'>
            <i class='fa-regular fa-clock me-1'></i>#timeFormat(locals.mEvent.start(), 'h:nn tt')# &mdash; #timeFormat(locals.mEvent.end(), 'h:nn tt')# #locals.mEvent.timezone_abbr()#
          </div>
        </cfif>
        <cfif locals.mEvent.description().len()>
          <div class='small mt-1'>#encodeForHTML(locals.mEvent.description())#</div>
        </cfif>
      </div>
      <cfif locals.mEvent.editable() && locals.editable>
        <div class='flex-shrink-0'>
          <button class='btn btn-sm btn-outline-nmg rounded-circle btn-edit-event' title='Edit'
            data-evid='#utility.encode(locals.mEvent.evid())#'
            data-summary='#encodeForHTML(locals.mEvent.summary())#'
            data-location='#encodeForHTML(locals.mEvent.location())#'
            data-description='#encodeForHTML(locals.mEvent.description())#'
            data-allday='#locals.mEvent.allday() ? 1 : 0#'
            data-timezone='#locals.mEvent.timezone()#'
            data-start='#locals.mEvent.start_date()#'
            data-start-time='#locals.mEvent.start_time()#'
            data-end='#locals.mEvent.end_date()#'
            data-end-time='#locals.mEvent.end_time()#'
          >
            <i class='fa-solid fa-fw fa-pencil'></i>
          </button>
        </div>
      </cfif>
    </div>
  </div>
</cfoutput>
