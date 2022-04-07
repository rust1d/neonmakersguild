DROP procedure IF EXISTS blogentriesrelated_get_by_ids;

delimiter ;;

CREATE PROCEDURE blogentriesrelated_get_by_ids(
  IN _ids text
)
BEGIN
  CALL create_temp_table_id_list(_ids);

  SELECT *
    FROM blogentriesrelated
         INNER JOIN _id_list ON _il_id = bre_breid;
END;;

delimiter ;
