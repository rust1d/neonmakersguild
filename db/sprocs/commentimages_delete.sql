DROP procedure IF EXISTS commentimages_delete;

delimiter ;;

CREATE PROCEDURE commentimages_delete(
  IN _ciid          INT(11)
)
BEGIN
  DELETE
    FROM commentimages
   WHERE ci_ciid = _ciid;

  SELECT ROW_COUNT() AS delete_count;
END;;

delimiter ;
