DROP procedure IF EXISTS blogcomments_delete;

delimiter ;;

CREATE PROCEDURE blogcomments_delete(
  IN _bcoid integer
)
BEGIN
  DELETE
    FROM blogcomments
   WHERE bco_bcoid = _bcoid;

  SELECT ROW_COUNT() AS delete_count;
END;;

delimiter ;
