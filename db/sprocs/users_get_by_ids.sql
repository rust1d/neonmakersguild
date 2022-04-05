DROP procedure IF EXISTS users_get_by_ids;

delimiter ;;

CREATE PROCEDURE users_get_by_ids(
  IN _ids text
)
BEGIN
  CALL create_temp_table_id_list(_ids);

  SELECT *
    FROM users
         INNER JOIN _id_list ON _il_id = us_usid;
END;;

delimiter ;
