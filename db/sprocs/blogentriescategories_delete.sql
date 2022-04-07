DROP procedure IF EXISTS blogentriescategories_delete;

delimiter ;;

CREATE PROCEDURE blogentriescategories_delete(
  IN _becid integer
)
BEGIN
  DELETE
    FROM blogentriescategories
   WHERE bec_becid = _becid;

  SELECT ROW_COUNT() AS delete_count;
END;;

delimiter ;
