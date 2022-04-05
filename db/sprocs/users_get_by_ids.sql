DROP procedure IF EXISTS user_get_by_ids;

delimiter ;;

CREATE PROCEDURE user_get_by_ids(
  IN _ids text
)
BEGIN
  CALL create_temp_table_id_list(_ids);

  SELECT *
    FROM user
         INNER JOIN _id_list ON _il_id = us_usid;
END;;

delimiter ;
