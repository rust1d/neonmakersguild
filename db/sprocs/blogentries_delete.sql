DROP procedure IF EXISTS blogentries_delete;

delimiter ;;

CREATE PROCEDURE blogentries_delete(
  IN _benid integer
)
BEGIN
  DELETE
    FROM blogentries
   WHERE ben_benid = _benid;

  SELECT ROW_COUNT() AS delete_count;
END;;

delimiter ;
