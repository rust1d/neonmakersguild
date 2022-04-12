DROP procedure IF EXISTS blogtextblocks_delete;

delimiter ;;

CREATE PROCEDURE blogtextblocks_delete(
  IN _btbid integer
)
BEGIN
  DELETE
    FROM blogtextblocks
   WHERE btb_btbid = _btbid;

  SELECT ROW_COUNT() AS delete_count;
END;;

delimiter ;
