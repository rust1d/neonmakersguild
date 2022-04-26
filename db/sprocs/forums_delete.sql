DROP procedure IF EXISTS forums_delete;

delimiter ;;

CREATE PROCEDURE forums_delete(
  IN _foid integer
)
BEGIN
  DELETE
    FROM forums
   WHERE fo_foid = _foid;

  SELECT ROW_COUNT() AS delete_count;
END;;

delimiter ;
