DROP procedure IF EXISTS events_get_by_ids;

delimiter ;;

CREATE PROCEDURE events_get_by_ids(
  IN _ids text
)
BEGIN
  CALL create_temp_table_id_list(_ids);

  SELECT *
    FROM events
         INNER JOIN _id_list ON _il_id = ev_evid;
END;;

delimiter ;
