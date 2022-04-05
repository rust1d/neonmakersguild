DROP procedure IF EXISTS users_delete;

delimiter ;;

CREATE PROCEDURE users_delete(
  IN _usid integer
)
BEGIN
  DELETE
    FROM users
   WHERE us_usid = _usid;

  SELECT ROW_COUNT() AS delete_count;
END;;

delimiter ;
