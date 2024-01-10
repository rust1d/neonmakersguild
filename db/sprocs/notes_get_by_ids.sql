DROP procedure IF EXISTS notes_get_by_ids;

delimiter ;;

CREATE PROCEDURE notes_get_by_ids(
  IN _ids text
)
BEGIN
  CALL create_temp_table_id_list(_ids);

  SELECT *
    FROM notes
         INNER JOIN _id_list ON _il_id = no_noid;
END;;

delimiter ;
