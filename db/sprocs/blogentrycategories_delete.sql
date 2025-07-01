DROP procedure IF EXISTS blogentrycategories_delete;

delimiter ;;

CREATE PROCEDURE blogentrycategories_delete(
  IN _becid integer
)
BEGIN
  DELETE
    FROM blogentrycategories
   WHERE bec_becid = _becid;

  SELECT ROW_COUNT() AS delete_count;
END;;

delimiter ;
