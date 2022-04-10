DROP procedure IF EXISTS blogpages_get_by_ids;

delimiter ;;

CREATE PROCEDURE blogpages_get_by_ids(
  IN _ids text
)
BEGIN
  CALL create_temp_table_id_list(_ids);

  SELECT *
    FROM blogpages
         INNER JOIN _id_list ON _il_id = bpa_bpaid;
END;;

delimiter ;
