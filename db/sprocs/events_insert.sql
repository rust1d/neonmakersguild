DROP procedure IF EXISTS events_insert;

delimiter ;;

CREATE PROCEDURE events_insert(
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

  INSERT INTO events (
    ev_usid, ev_google_id, ev_summary, ev_location, ev_description, ev_allday, ev_timezone, ev_start, ev_end,
    ev_added, ev_dla
  ) VALUES (
    _usid, _google_id, _summary, _location, _description, _allday, _timezone, _start, _end,
    CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
  );

  CALL events_get_by_ids(LAST_INSERT_ID());
END;;

delimiter ;
