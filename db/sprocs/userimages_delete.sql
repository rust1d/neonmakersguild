DROP procedure IF EXISTS userimages_delete;

delimiter ;;

CREATE PROCEDURE userimages_delete(
  IN _uiid integer
)
BEGIN
  DELETE
    FROM userimages
   WHERE ui_uiid = _uiid;

  SELECT ROW_COUNT() AS delete_count;
END;;

delimiter ;
