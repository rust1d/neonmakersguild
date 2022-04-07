DROP procedure IF EXISTS blogcomments_get_by_ids;

delimiter ;;

CREATE PROCEDURE blogcomments_get_by_ids(
  IN _ids text
)
BEGIN
  CALL create_temp_table_id_list(_ids);

  SELECT *
    FROM blogcomments
         INNER JOIN _id_list ON _il_id = bco_bcoid;
END;;

delimiter ;
