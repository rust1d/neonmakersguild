DROP procedure IF EXISTS documentcategories_get_by_ids;

delimiter ;;

CREATE PROCEDURE documentcategories_get_by_ids(
  IN _ids text
)
BEGIN
  CALL create_temp_table_id_list(_ids);

  SELECT *
    FROM documentcategories
         INNER JOIN _id_list ON _il_id = dc_dcid;
END;;

delimiter ;
