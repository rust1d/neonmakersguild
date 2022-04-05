DROP procedure IF EXISTS userlinks_delete;

delimiter ;;

CREATE PROCEDURE userlinks_delete(
  IN _ulid integer
)
BEGIN
  DELETE
    FROM userlinks
   WHERE ul_ulid = _ulid;

  SELECT ROW_COUNT() AS delete_count;
END;;

delimiter ;
