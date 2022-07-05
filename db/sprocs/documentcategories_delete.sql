DROP procedure IF EXISTS documentcategories_delete;

delimiter ;;

CREATE PROCEDURE documentcategories_delete(
  IN _dcid integer
)
BEGIN
  DELETE
    FROM documentcategories
   WHERE dc_dcid = _dcid;

  SELECT ROW_COUNT() AS delete_count;
END;;

delimiter ;
