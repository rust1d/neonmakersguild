DROP procedure IF EXISTS blogroles_get_by_ids;

delimiter ;;

CREATE PROCEDURE blogroles_get_by_ids(
  IN _ids text
)
BEGIN
  CALL create_temp_table_id_list(_ids);

  SELECT *
    FROM blogroles
         INNER JOIN _id_list ON _il_id = bro_broid;
END;;

delimiter ;
