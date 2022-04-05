DROP procedure IF EXISTS userprofile_delete;

delimiter ;;

CREATE PROCEDURE userprofile_delete(
  IN _upid integer
)
BEGIN
  DELETE
    FROM userprofile
   WHERE up_upid = _upid;

  SELECT ROW_COUNT() AS delete_count;
END;;

delimiter ;
