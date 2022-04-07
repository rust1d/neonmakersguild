DROP procedure IF EXISTS blogcategories_delete;

delimiter ;;

CREATE PROCEDURE blogcategories_delete(
  IN _bcaid integer
)
BEGIN
  DELETE
    FROM blogcategories
   WHERE bca_bcaid = _bcaid;

  SELECT ROW_COUNT() AS delete_count;
END;;

delimiter ;
