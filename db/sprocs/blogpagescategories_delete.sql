DROP procedure IF EXISTS blogpagescategories_delete;

delimiter ;;

CREATE PROCEDURE blogpagescategories_delete(
  IN _bpcid integer
)
BEGIN
  DELETE
    FROM blogpagescategories
   WHERE bpc_bpcid = _bpcid;

  SELECT ROW_COUNT() AS delete_count;
END;;

delimiter ;
