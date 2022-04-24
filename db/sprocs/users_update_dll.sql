DROP procedure IF EXISTS users_update_dll;

delimiter ;;

CREATE PROCEDURE users_update_dll(
  IN _usid          int(11)
)
BEGIN
  UPDATE users
     SET us_dll = CURRENT_TIMESTAMP
   WHERE us_usid = _usid;
END;;

delimiter ;
