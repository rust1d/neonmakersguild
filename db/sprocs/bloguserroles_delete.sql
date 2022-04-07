DROP procedure IF EXISTS bloguserroles_delete;

delimiter ;;

CREATE PROCEDURE bloguserroles_delete(
  IN _burid integer
)
BEGIN
  DELETE
    FROM bloguserroles
   WHERE bur_burid = _burid;

  SELECT ROW_COUNT() AS delete_count;
END;;

delimiter ;
