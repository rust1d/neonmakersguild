DROP procedure IF EXISTS subscriptions_delete;

delimiter ;;

CREATE PROCEDURE subscriptions_delete(
  IN _ssid integer
)
BEGIN
  DELETE
    FROM subscriptions
   WHERE ss_ssid = _ssid;

  SELECT ROW_COUNT() AS delete_count;
END;;

delimiter ;
