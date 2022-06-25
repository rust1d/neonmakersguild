DROP procedure IF EXISTS documenttags_get_by_ids;

delimiter ;;

CREATE PROCEDURE documenttags_get_by_ids(
  IN _ids text
)
BEGIN
  CALL create_temp_table_id_list(_ids);

  SELECT *
    FROM documenttags
         INNER JOIN _id_list ON _il_id = dt_dtid;
END;;

delimiter ;
