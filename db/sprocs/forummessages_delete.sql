DROP procedure IF EXISTS forummessages_delete;

delimiter ;;

CREATE PROCEDURE forummessages_delete(
  IN _fmid integer
)
BEGIN
  DELETE
    FROM forummessages
   WHERE fm_fmid = _fmid;

  SELECT ROW_COUNT() AS delete_count;
END;;

delimiter ;
