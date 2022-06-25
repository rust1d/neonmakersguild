DROP procedure IF EXISTS tags_get_by_ids;

delimiter ;;

CREATE PROCEDURE tags_get_by_ids(
  IN _ids text
)
BEGIN
  CALL create_temp_table_id_list(_ids);

  SELECT *
    FROM tags
         INNER JOIN _id_list ON _il_id = tag_tagid;
END;;

delimiter ;
