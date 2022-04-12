DROP procedure IF EXISTS blogtextblocks_get_by_ids;

delimiter ;;

CREATE PROCEDURE blogtextblocks_get_by_ids(
  IN _ids text
)
BEGIN
  CALL create_temp_table_id_list(_ids);

  SELECT *
    FROM blogtextblocks
         INNER JOIN _id_list ON _il_id = btb_btbid;
END;;

delimiter ;
