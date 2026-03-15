<cfscript>
  param form.ev_evid = '';
  param form.ev_summary = '';
  param form.ev_location = '';
  param form.ev_description = '';
  param form.ev_allday = 0;
  param form.ev_timezone = 'America/New_York';
  param form.ev_start = '';
  param form.ev_start_time = '';
  param form.ev_end = '';
  param form.ev_end_time = '';

  if (session.user.loggedIn() && form.keyExists('btnSubmitEvent')) {
    try {
      if (form.ev_summary.trim().len() == 0) throw(type: 'validation_error', message: 'Event title is required.');
      if (form.ev_allday) {
        param form.ev_ad_start = '';
        param form.ev_ad_end = '';
        if (form.ev_ad_start.trim().len() == 0) throw(type: 'validation_error', message: 'Start date is required.');
        start_val = form.ev_ad_start;
        end_val = form.ev_ad_end.trim().len() ? form.ev_ad_end : dateFormat(dateAdd('d', 1, form.ev_ad_start), 'yyyy-mm-dd');
      } else {
        if (form.ev_start.trim().len() == 0) throw(type: 'validation_error', message: 'Start date is required.');
        if (form.ev_start_time.trim().len() == 0) throw(type: 'validation_error', message: 'Start time is required for timed events.');
        if (form.ev_end_time.trim().len() == 0) throw(type: 'validation_error', message: 'End time is required for timed events.');
        if (form.ev_end.trim().len() == 0) throw(type: 'validation_error', message: 'End date is required.');
        start_val = form.ev_start & 'T' & form.ev_start_time & ':00';
        end_val = form.ev_end & 'T' & form.ev_end_time & ':00';
      }

      evid = utility.decode(form.ev_evid);
      gcal = new app.services.GoogleCalendar().init();

      if (evid) {
        mEvent = new app.models.Events().find(evid);
        if (!mEvent.editable()) throw(type: 'validation_error', message: 'You do not have permission to edit this event.');

        if (mEvent.google_id().len()) {
          gcal.update_event(
            event_id: mEvent.google_id(), summary: form.ev_summary.trim(),
            start_date: start_val, end_date: end_val,
            description: form.ev_description.trim(), location: form.ev_location.trim(),
            all_day: form.ev_allday ? true : false, timezone: form.ev_timezone
          );
        }

        mEvent.set(
          ev_summary: form.ev_summary.trim(),
          ev_location: form.ev_location.trim(),
          ev_description: form.ev_description.trim(),
          ev_allday: form.ev_allday ? 1 : 0,
          ev_timezone: form.ev_timezone,
          ev_start: start_val,
          ev_end: end_val
        ).safe_save();

        flash.success('Event updated!');
      } else {
        result = gcal.create_event(
          summary: form.ev_summary.trim(),
          start_date: start_val,
          end_date: end_val,
          description: form.ev_description.trim(),
          location: form.ev_location.trim(),
          all_day: form.ev_allday ? true : false,
          timezone: form.ev_timezone
        );

        new app.models.Events({
          ev_usid: session.user.usid(),
          ev_google_id: result.event.id ?: '',
          ev_summary: form.ev_summary.trim(),
          ev_location: form.ev_location.trim(),
          ev_description: form.ev_description.trim(),
          ev_allday: form.ev_allday ? 1 : 0,
          ev_timezone: form.ev_timezone,
          ev_start: start_val,
          ev_end: end_val
        }).safe_save();

        flash.success('Event added to the NMG calendar!');
      }

      router.reload();
    } catch (validation_error err) {
      flash.error(err.message);
      router.reload();
    } catch (any err) {
      flash.cferror(err);
      router.reload();
    }
  }
</cfscript>

<cfoutput>
  <div class='offcanvas offcanvas-end' tabindex='-1' id='addEventDrawer'>
    <div class='offcanvas-header bg-nmg-dark text-white'>
      <h5 class='text-marker mb-0'><i class='fa-solid fa-calendar-plus me-2'></i>Add an Event</h5>
      <button type='button' class='btn-close btn-close-white' data-bs-dismiss='offcanvas'></button>
    </div>
    <div class='offcanvas-body'>
      <form method='post' autocomplete='off' id='eventForm'>
        <input type='hidden' id='ev_evid' name='ev_evid' value='' />
        <div class='row g-3'>
          <div class='col-12'>
            <label class='form-label required' for='ev_summary'>Event Title</label>
            <input type='text' class='form-control' id='ev_summary' name='ev_summary' value='#encodeForHTML(form.ev_summary)#' maxlength='200' required />
          </div>
          <div class='col-12'>
            <label class='form-label required' for='ev_location'>Location</label>
            <input type='text' class='form-control' id='ev_location' name='ev_location' value='#encodeForHTML(form.ev_location)#' maxlength='500' required />
            <div class='form-text text-muted text-smaller'>Location or link to meeting</div>
          </div>
          <div class='col-12'>
            <label class='form-label' for='ev_description'>Description</label>
            <textarea class='form-control' id='ev_description' name='ev_description' rows='6' maxlength='2000'>#encodeForHTML(form.ev_description)#</textarea>
          </div>
          <div class='col-12'>
            <div class='form-check'>
              <input type='checkbox' class='form-check-input' id='ev_allday' name='ev_allday' value='1' #ifin(form.ev_allday == 1, 'checked')# />
              <label class='form-check-label' for='ev_allday'>All-day event</label>
            </div>
          </div>
          <div class='col-12 allday-field'>
            <label class='form-label required'>Dates</label>
            <div class='input-group'>
              <input type='date' class='form-control' name='ev_ad_start' value='#form.ev_start#' required />
              <span class='input-group-text'>to</span>
              <input type='date' class='form-control' name='ev_ad_end' value='#form.ev_end#' />
            </div>
            <div class='form-text text-muted text-smaller'>End date optional for single-day events</div>
          </div>
          <div class='col-12 timed-field'>
            <label class='form-label required'>Start</label>
            <div class='input-group'>
              <input type='date' class='form-control' name='ev_start' value='#form.ev_start#' required />
              <input type='time' class='form-control' id='ev_start_time' name='ev_start_time' value='#form.ev_start_time#' required />
            </div>
          </div>
          <div class='col-12 timed-field'>
            <label class='form-label required'>End</label>
            <div class='input-group'>
              <input type='date' class='form-control' name='ev_end' value='#form.ev_end#' required />
              <input type='time' class='form-control' id='ev_end_time' name='ev_end_time' value='#form.ev_end_time#' />
            </div>
          </div>
          <div class='col-12 timed-field'>
            <label class='form-label' for='ev_timezone'>Timezone</label>
            <select class='form-select' name='ev_timezone' id='ev_timezone'>
              <cfloop list='America/New_York,America/Chicago,America/Denver,America/Los_Angeles,America/Anchorage,Pacific/Honolulu,Europe/London,Europe/Paris,Europe/Berlin,Asia/Tokyo,Australia/Sydney' item='tz'>
                <option value='#tz#' #ifin(form.ev_timezone==tz, 'selected')#>#tz.replace('_', ' ', 'all')#</option>
              </cfloop>
            </select>
          </div>
          <div class='col-12 mt-4'>
            <button type='submit' name='btnSubmitEvent' class='btn btn-nmg rounded-pill px-4'><i class='fa-solid fa-calendar-check me-2'></i>Save Event</button>
            <button type='button' class='btn btn-outline-nmg rounded-pill px-4 ms-2' data-bs-dismiss='offcanvas'>Cancel</button>
          </div>
        </div>
      </form>
    </div>
  </div>
</cfoutput>

<cfset include_js('assets/js/calendar/edit.js') />
