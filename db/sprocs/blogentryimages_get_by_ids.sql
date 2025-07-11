DROP procedure IF EXISTS blogentryimages_get_by_ids;

delimiter ;;

CREATE PROCEDURE blogentryimages_get_by_ids(
  IN _ids text
)
BEGIN
  CALL create_temp_table_id_list(_ids);

  SELECT *
    FROM blogentryimages
         INNER JOIN _id_list ON _il_id = bei_beiid;
END;;

delimiter ;
