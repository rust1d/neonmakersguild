DROP procedure IF EXISTS events_delete;

delimiter ;;

CREATE PROCEDURE events_delete(
  IN _evid integer
)
BEGIN
  DELETE
    FROM events
   WHERE ev_evid = _evid;

  SELECT ROW_COUNT() AS delete_count;
END;;

delimiter ;
