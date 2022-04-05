DROP procedure IF EXISTS userimages_get_by_ids;

delimiter ;;

CREATE PROCEDURE userimages_get_by_ids(
  IN _ids text
)
BEGIN
  CALL create_temp_table_id_list(_ids);

  SELECT *
    FROM userimages
         INNER JOIN _id_list ON _il_id = ui_uiid;
END;;

delimiter ;
