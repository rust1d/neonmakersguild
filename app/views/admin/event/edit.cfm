<cfscript>
  evid = router.decode('evid');
  mEvent = evid ? new app.models.Events().find(evid) : new app.models.Events();

  if (form.keyExists('btnDelete') && mEvent.persisted()) {
    if (mEvent.google_id().len()) {
      try { new app.services.GoogleCalendar().init().delete_event(mEvent.google_id()); } catch (any e) {}
    }
    mEvent.destroy();
    flash.success('Event deleted.');
    router.redirect('event/list');
  }

  if (form.keyExists('btnSubmit')) {
    try {
      param form.ev_allday = 0;

      if (form.ev_summary.trim().len() == 0) throw(type: 'validation_error', message: 'Event title is required.');

      if (form.ev_allday) {
        param form.ev_ad_start = '';
        param form.ev_ad_end = '';
        if (form.ev_ad_start.trim().len() == 0) throw(type: 'validation_error', message: 'Start date is required.');
        start_val = form.ev_ad_start;
        end_val = form.ev_ad_end.trim().len() ? form.ev_ad_end : dateFormat(dateAdd('d', 1, form.ev_ad_start), 'yyyy-mm-dd');
      } else {
        if (form.ev_start.trim().len() == 0) throw(type: 'validation_error', message: 'Start date is required.');
        if (form.ev_start_time.trim().len() == 0) throw(type: 'validation_error', message: 'Start time is required.');
        if (form.ev_end_time.trim().len() == 0) throw(type: 'validation_error', message: 'End time is required.');
        if (form.ev_end.trim().len() == 0) throw(type: 'validation_error', message: 'End date is required.');
        start_val = form.ev_start.trim() & 'T' & form.ev_start_time & ':00';
        end_val = form.ev_end.trim() & 'T' & form.ev_end_time & ':00';
      }

      event_data = {
        ev_summary: form.ev_summary.trim(),
        ev_location: form.ev_location.trim(),
        ev_description: form.ev_description.trim(),
        ev_allday: form.ev_allday ? 1 : 0,
        ev_timezone: form.ev_timezone,
        ev_start: start_val,
        ev_end: end_val
      };

      gcal_args = {
        summary: event_data.ev_summary,
        start_date: start_val,
        end_date: end_val,
        description: event_data.ev_description,
        location: event_data.ev_location,
        all_day: form.ev_allday ? true : false,
        timezone: form.ev_timezone
      };

      gcal = new app.services.GoogleCalendar().init();

      if (mEvent.persisted()) {
        if (mEvent.google_id().len()) {
          try { gcal.update_event(event_id: mEvent.google_id(), argumentcollection: gcal_args); } catch (any e) {}
        }
        mEvent.set(event_data).safe_save();
      } else {
        result = gcal.create_event(argumentcollection: gcal_args);
        event_data.ev_usid = 1;
        event_data.ev_google_id = result.event.id ?: '';
        new app.models.Events(event_data).safe_save();
      }

      flash.success('Event saved.');
      router.redirect('event/list');
    } catch (validation_error err) {
      flash.error(err.message);
    } catch (any err) {
      flash.cferror(err);
    }
  }

  mode = mEvent.new_record() ? 'Add' : 'Edit';
</cfscript>

<cfoutput>
  <div class='row mb-3'>
    <div class='col'>
      <form role='form' method='post' id='eventForm'>
        <div class='card'>
          <div class='card-header bg-nmg'>
            <div class='row'>
              <div class='col fs-5'>#mode# Event</div>
            </div>
          </div>
          <div class='card-body'>
            <div class='row g-3'>
              <div class='col-md-8'>
                <label class='form-label required' for='ev_summary'>Event Title</label>
                <input type='text' class='form-control' name='ev_summary' id='ev_summary' value='#encodeForHTML(mEvent.summary())#' maxlength='200' required />
              </div>
              <div class='col-md-4'>
                <label class='form-label required' for='ev_location'>Location</label>
                <input type='text' class='form-control' name='ev_location' id='ev_location' value='#encodeForHTML(mEvent.location())#' maxlength='500' required />
              </div>
              <div class='col-12'>
                <label class='form-label' for='ev_description'>Description</label>
                <textarea class='form-control' name='ev_description' id='ev_description' rows='4' maxlength='2000'>#encodeForHTML(mEvent.description())#</textarea>
              </div>
              <div class='col-12'>
                <div class='form-check'>
                  <input type='checkbox' class='form-check-input' id='ev_allday' name='ev_allday' value='1' #ifin(mEvent.allday(), 'checked')# />
                  <label class='form-check-label' for='ev_allday'>All-day event</label>
                </div>
              </div>
              <div class='col-md-6 allday-field'>
                <label class='form-label required'>Dates</label>
                <div class='input-group'>
                  <input type='date' class='form-control' name='ev_ad_start' value='#mEvent.start_date()#' required />
                  <span class='input-group-text'>to</span>
                  <input type='date' class='form-control' name='ev_ad_end' value='#mEvent.end_date()#' />
                </div>
              </div>
              <div class='col-md-3 timed-field'>
                <label class='form-label required'>Start</label>
                <div class='input-group'>
                  <input type='date' class='form-control' name='ev_start' value='#mEvent.start_date()#' required />
                  <input type='time' class='form-control' name='ev_start_time' value='#mEvent.start_time()#' required />
                </div>
              </div>
              <div class='col-md-3 timed-field'>
                <label class='form-label required'>End</label>
                <div class='input-group'>
                  <input type='date' class='form-control' name='ev_end' value='#mEvent.end_date()#' required />
                  <input type='time' class='form-control' name='ev_end_time' value='#mEvent.end_time()#' />
                </div>
              </div>
              <div class='col-md-3 timed-field'>
                <label class='form-label' for='ev_timezone'>Timezone</label>
                <select class='form-select' name='ev_timezone' id='ev_timezone'>
                  <cfloop list='America/New_York,America/Chicago,America/Denver,America/Los_Angeles,America/Anchorage,Pacific/Honolulu,Europe/London,Europe/Paris,Europe/Berlin,Asia/Tokyo,Australia/Sydney' item='tz'>
                    <option value='#tz#' #ifin(mEvent.timezone()==tz, 'selected')#>#tz.replace('_', ' ', 'all')#</option>
                  </cfloop>
                </select>
              </div>
              <cfif mEvent.persisted() && mEvent.google_id().len()>
                <div class='col-12 small text-muted'>
                  <i class='fa-solid fa-calendar-check me-1'></i>Google Calendar ID: #mEvent.google_id()#
                </div>
              </cfif>
            </div>
            <div class='row mt-3'>
              <div class='col text-center'>
                <button type='submit' name='btnSubmit' class='btn btn-nmg'>Save</button>
                <a href='#router.href("event/list")#' class='btn btn-nmg-cancel'>Cancel</a>
                <cfif mEvent.persisted()>
                  <button type='submit' name='btnDelete' class='btn btn-danger ms-3' onclick='return confirm("Delete this event?")'>Delete</button>
                </cfif>
              </div>
            </div>
          </div>
        </div>
      </form>
    </div>
  </div>
</cfoutput>

<cfset include_js('assets/js/calendar/edit.js') />
