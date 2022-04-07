DROP procedure IF EXISTS blogentriescategories_get_by_ids;

delimiter ;;

CREATE PROCEDURE blogentriescategories_get_by_ids(
  IN _ids text
)
BEGIN
  CALL create_temp_table_id_list(_ids);

  SELECT *
    FROM blogentriescategories
         INNER JOIN _id_list ON _il_id = bec_becid;
END;;

delimiter ;
