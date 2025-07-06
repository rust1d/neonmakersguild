DROP procedure IF EXISTS commentimages_get_by_ids;

delimiter ;;

CREATE PROCEDURE commentimages_get_by_ids(
  IN _ids text
)
BEGIN
  CALL create_temp_table_id_list(_ids);

  SELECT *
    FROM commentimages
         INNER JOIN _id_list ON _il_id = ci_ciid;
END;;

delimiter ;
