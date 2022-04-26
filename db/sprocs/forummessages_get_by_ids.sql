DROP procedure IF EXISTS forummessages_get_by_ids;

delimiter ;;

CREATE PROCEDURE forummessages_get_by_ids(
  IN _ids text
)
BEGIN
  CALL create_temp_table_id_list(_ids);

  SELECT *
    FROM forummessages
         INNER JOIN _id_list ON _il_id = fm_fmid;
END;;

delimiter ;
