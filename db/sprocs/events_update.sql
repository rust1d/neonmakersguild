DROP procedure IF EXISTS events_update;

delimiter ;;

CREATE PROCEDURE events_update(
  IN _evid        int(11) unsigned,
  IN _usid        int(11),
  IN _google_id   varchar(200),
  IN _summary     varchar(200),
  IN _location    varchar(500),
  IN _description varchar(2000),
  IN _allday      tinyint(1),
  IN _timezone    varchar(50),
  IN _start       datetime,
  IN _end         datetime
)
BEGIN
  UPDATE events
     SET ev_usid        = IFNULL(_usid,        ev_usid),
         ev_google_id   = IFNULL(_google_id,   ev_google_id),
         ev_summary     = IFNULL(_summary,     ev_summary),
         ev_location    = IFNULL(_location,    ev_location),
         ev_description = IFNULL(_description, ev_description),
         ev_allday      = IFNULL(_allday,      ev_allday),
         ev_timezone    = IFNULL(_timezone,   ev_timezone),
         ev_start       = IFNULL(_start,       ev_start),
         ev_end         = IFNULL(_end,         ev_end),
         ev_dla         = CURRENT_TIMESTAMP
   WHERE ev_evid = _evid;

  CALL events_get_by_ids(_evid);
END;;

delimiter ;
