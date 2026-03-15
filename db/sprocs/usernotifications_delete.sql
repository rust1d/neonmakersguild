DROP procedure IF EXISTS usernotifications_delete;

delimiter ;;

CREATE PROCEDURE usernotifications_delete(
  IN _unid         INT(11)
)
BEGIN
  DELETE
    FROM usernotifications
   WHERE un_unid = _unid;

  SELECT ROW_COUNT() AS delete_count;
END;;

delimiter ;
