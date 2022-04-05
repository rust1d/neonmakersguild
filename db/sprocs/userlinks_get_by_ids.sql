DROP procedure IF EXISTS userlinks_get_by_ids;

delimiter ;;

CREATE PROCEDURE userlinks_get_by_ids(
  IN _ids text
)
BEGIN
  CALL create_temp_table_id_list(_ids);

  SELECT *
    FROM userlinks
         INNER JOIN _id_list ON _il_id = ul_ulid;
END;;

delimiter ;
