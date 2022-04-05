DROP procedure IF EXISTS userprofile_get_by_ids;

delimiter ;;

CREATE PROCEDURE userprofile_get_by_ids(
  IN _ids text
)
BEGIN
  CALL create_temp_table_id_list(_ids);

  SELECT *
    FROM userprofile
         INNER JOIN _id_list ON _il_id = up_upid;
END;;

delimiter ;
