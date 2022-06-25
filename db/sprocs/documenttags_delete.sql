DROP procedure IF EXISTS documenttags_delete;

delimiter ;;

CREATE PROCEDURE documenttags_delete(
  IN _dtid integer
)
BEGIN
  DELETE
    FROM documenttags
   WHERE dt_dtid = _dtid;

  SELECT ROW_COUNT() AS delete_count;
END;;

delimiter ;
