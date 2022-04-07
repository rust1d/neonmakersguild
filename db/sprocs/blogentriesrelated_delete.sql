DROP procedure IF EXISTS blogentriesrelated_delete;

delimiter ;;

CREATE PROCEDURE blogentriesrelated_delete(
  IN _breid integer
)
BEGIN
  DELETE
    FROM blogentriesrelated
   WHERE bre_breid = _breid;

  SELECT ROW_COUNT() AS delete_count;
END;;

delimiter ;
