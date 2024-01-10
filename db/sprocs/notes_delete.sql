DROP procedure IF EXISTS notes_delete;

delimiter ;;

CREATE PROCEDURE notes_delete(
  IN _noid integer
)
BEGIN
  DELETE
    FROM notes
   WHERE no_noid = _noid;

  SELECT ROW_COUNT() AS delete_count;
END;;

delimiter ;
