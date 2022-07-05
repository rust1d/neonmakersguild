DROP procedure IF EXISTS memberrequests_get_by_ids;

delimiter ;;

CREATE PROCEDURE memberrequests_get_by_ids(
  IN _ids text
)
BEGIN
  CALL create_temp_table_id_list(_ids);

  SELECT *
    FROM memberrequests
         INNER JOIN _id_list ON _il_id = mr_mrid;
END;;

delimiter ;
