DROP procedure IF EXISTS blogpagescategories_get_by_ids;

delimiter ;;

CREATE PROCEDURE blogpagescategories_get_by_ids(
  IN _ids text
)
BEGIN
  CALL create_temp_table_id_list(_ids);

  SELECT *
    FROM blogpagescategories
         INNER JOIN _id_list ON _il_id = bpc_bpcid;
END;;

delimiter ;
