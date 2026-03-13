DROP procedure IF EXISTS subscriptions_delete_batch;

delimiter ;;

CREATE PROCEDURE subscriptions_delete_batch(
  IN _ssids text
)
BEGIN
  CALL create_temp_table_id_list(_ssids);

  DELETE subscriptions
    FROM subscriptions
         INNER JOIN _id_list ON _il_id = ss_ssid;

  SELECT ROW_COUNT() AS delete_count;
END;;

delimiter ;
