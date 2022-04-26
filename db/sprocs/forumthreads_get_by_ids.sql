DROP procedure IF EXISTS forumthreads_get_by_ids;

delimiter ;;

CREATE PROCEDURE forumthreads_get_by_ids(
  IN _ids text
)
BEGIN
  CALL create_temp_table_id_list(_ids);

  SELECT *
    FROM forumthreads
         INNER JOIN _id_list ON _il_id = ft_ftid;
END;;

delimiter ;
