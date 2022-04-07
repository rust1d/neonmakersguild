DROP procedure IF EXISTS blogentries_get_by_ids;

delimiter ;;

CREATE PROCEDURE blogentries_get_by_ids(
  IN _ids text
)
BEGIN
  CALL create_temp_table_id_list(_ids);

  SELECT *
    FROM blogentries
         INNER JOIN _id_list ON _il_id = ben_benid;
END;;

delimiter ;
