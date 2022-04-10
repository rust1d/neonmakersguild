DROP procedure IF EXISTS blogpages_delete;

delimiter ;;

CREATE PROCEDURE blogpages_delete(
  IN _bpaid integer
)
BEGIN
  DELETE
    FROM blogpages
   WHERE bpa_bpaid = _bpaid;

  SELECT ROW_COUNT() AS delete_count;
END;;

delimiter ;
