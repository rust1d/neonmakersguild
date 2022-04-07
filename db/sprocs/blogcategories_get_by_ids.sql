DROP procedure IF EXISTS blogcategories_get_by_ids;

delimiter ;;

CREATE PROCEDURE blogcategories_get_by_ids(
  IN _ids text
)
BEGIN
  CALL create_temp_table_id_list(_ids);

  SELECT *
    FROM blogcategories
         INNER JOIN _id_list ON _il_id = bca_bcaid;
END;;

delimiter ;
