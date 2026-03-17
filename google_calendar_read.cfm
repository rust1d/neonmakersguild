<cfscript>
  gcal = new app.services.GoogleCalendar().init();
  events = gcal.list_events();
  imported = 0;
  skipped = 0;

  for (ev in events) {
    // skip if already in db
    if (new app.models.Events().count(ev_google_id: ev.id)) {
      skipped++;
      continue;
    }

    is_allday = ev.start.keyExists('date');

    if (is_allday) {
      start_val = ev.start.date;
      end_val = ev.end.date ?: ev.start.date;
    } else {
      start_val = ev.start.dateTime ?: '';
      end_val = ev.end.dateTime ?: '';
    }

    new app.models.Events({
      ev_usid: 1,
      ev_google_id: ev.id,
      ev_summary: ev.summary ?: '',
      ev_location: ev.location ?: '',
      ev_description: ev.description ?: '',
      ev_allday: is_allday ? 1 : 0,
      ev_timezone: ev.start.timeZone ?: 'America/New_York',
      ev_start: start_val,
      ev_end: end_val
    }).safe_save();

    imported++;
  }

  writeOutput('Done. Imported: #imported#, Skipped (already exists): #skipped#, Total from Google: #events.len()#');
</cfscript>
