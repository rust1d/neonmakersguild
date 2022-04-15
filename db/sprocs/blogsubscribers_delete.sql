DROP procedure IF EXISTS blogsubscribers_delete;

delimiter ;;

CREATE PROCEDURE blogsubscribers_delete(
  IN _bsuid integer
)
BEGIN
  DELETE
    FROM blogsubscribers
   WHERE bsu_bsuid = _bsuid;

  SELECT ROW_COUNT() AS delete_count;
END;;

delimiter ;
