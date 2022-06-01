DROP procedure IF EXISTS forums_get_by_ids;

delimiter ;;

CREATE PROCEDURE forums_get_by_ids(
  IN _ids text
)
BEGIN
  CALL create_temp_table_id_list(_ids);

  SELECT *
    FROM forums
         INNER JOIN _id_list ON _il_id = fo_foid
   ORDER BY fo_order;
END;;

delimiter ;
