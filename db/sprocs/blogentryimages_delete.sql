DROP procedure IF EXISTS blogentryimages_delete;

delimiter ;;

CREATE PROCEDURE blogentryimages_delete(
  IN _beiid         INT(11)
)
BEGIN
  DELETE
    FROM blogentryimages
   WHERE bei_beiid = _beiid;

  SELECT ROW_COUNT() AS delete_count;
END;;

delimiter ;
