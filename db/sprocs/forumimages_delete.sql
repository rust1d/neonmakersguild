DROP procedure IF EXISTS forumimages_delete;

delimiter ;;

CREATE PROCEDURE forumimages_delete(
  IN _fiid          INT(11)
)
BEGIN
  DELETE
    FROM forumimages
   WHERE fi_fiid = _fiid;

  SELECT ROW_COUNT() AS delete_count;
END;;

delimiter ;
