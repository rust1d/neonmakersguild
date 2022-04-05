DROP procedure IF EXISTS user_delete;

delimiter ;;

CREATE PROCEDURE user_delete(
  IN _usid integer
)
BEGIN
  DELETE
    FROM user
   WHERE us_usid = _usid;

  SELECT ROW_COUNT() AS delete_count;
END;;

delimiter ;
