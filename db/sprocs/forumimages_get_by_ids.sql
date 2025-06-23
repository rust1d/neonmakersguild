DROP procedure IF EXISTS forumimages_get_by_ids;

delimiter ;;

CREATE PROCEDURE forumimages_get_by_ids(
  IN _ids text
)
BEGIN
  CALL create_temp_table_id_list(_ids);

  SELECT *
    FROM forumimages
         INNER JOIN _id_list ON _il_id = fi_fiid;
END;;

delimiter ;
