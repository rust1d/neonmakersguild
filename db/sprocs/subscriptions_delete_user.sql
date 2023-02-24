DROP procedure IF EXISTS subscriptions_delete_user;

delimiter ;;

CREATE PROCEDURE subscriptions_delete_user(
  IN _usid integer
)
BEGIN
  DELETE
    FROM subscriptions
   WHERE ss_usid = _usid;

  SELECT ROW_COUNT() AS delete_count;
END;;

delimiter ;
