DROP procedure IF EXISTS forumthreads_delete;

delimiter ;;

CREATE PROCEDURE forumthreads_delete(
  IN _ftid integer
)
BEGIN
  DELETE
    FROM forumthreads
   WHERE ft_ftid = _ftid;

  SELECT ROW_COUNT() AS delete_count;
END;;

delimiter ;
