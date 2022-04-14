DROP procedure IF EXISTS bloglinks_delete;

delimiter ;;

CREATE PROCEDURE bloglinks_delete(
  IN _bliid integer
)
BEGIN
  DELETE
    FROM bloglinks
   WHERE bli_bliid = _bliid;

  SELECT ROW_COUNT() AS delete_count;
END;;

delimiter ;
