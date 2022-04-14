DROP procedure IF EXISTS bloglinks_get_by_ids;

delimiter ;;

CREATE PROCEDURE bloglinks_get_by_ids(
  IN _ids text
)
BEGIN
  CALL create_temp_table_id_list(_ids);

  SELECT *
    FROM bloglinks
         INNER JOIN _id_list ON _il_id = bli_bliid;
END;;

delimiter ;
