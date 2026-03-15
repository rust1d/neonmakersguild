DROP procedure IF EXISTS usernotifications_get_by_ids;

delimiter ;;

CREATE PROCEDURE usernotifications_get_by_ids(
  IN _ids text
)
BEGIN
  CALL create_temp_table_id_list(_ids);

  SELECT *
    FROM usernotifications
         INNER JOIN _id_list ON _il_id = un_unid;
END;;

delimiter ;
