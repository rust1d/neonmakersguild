DROP procedure IF EXISTS memberrequests_delete;

delimiter ;;

CREATE PROCEDURE memberrequests_delete(
  IN _mrid integer
)
BEGIN
  DELETE
    FROM memberrequests
   WHERE mr_mrid = _mrid;

  SELECT ROW_COUNT() AS delete_count;
END;;

delimiter ;
