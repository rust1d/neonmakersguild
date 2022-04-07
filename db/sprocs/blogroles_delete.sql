DROP procedure IF EXISTS blogroles_delete;

delimiter ;;

CREATE PROCEDURE blogroles_delete(
  IN _broid integer
)
BEGIN
  DELETE
    FROM blogroles
   WHERE bro_broid = _broid;

  SELECT ROW_COUNT() AS delete_count;
END;;

delimiter ;
