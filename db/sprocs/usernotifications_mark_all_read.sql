DROP procedure IF EXISTS usernotifications_mark_all_read;

delimiter ;;

CREATE PROCEDURE usernotifications_mark_all_read(
  IN _usid INT
)
BEGIN
  UPDATE usernotifications
     SET un_read = 1
   WHERE un_usid = _usid
     AND un_read = 0;
END;;

delimiter ;
