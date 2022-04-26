DROP procedure IF EXISTS forumthreads_search;

delimiter ;;

CREATE PROCEDURE forumthreads_search(
  IN _ftid   int(11),
  IN _foid   int(11),
  IN _usid   int(11)
)
BEGIN
  SELECT forumthreads.*, fo_alias
    FROM forumthreads
         INNER JOIN forums ON fo_foid = ft_foid
   WHERE ft_deleted IS NULL
     AND (_ftid IS NULL OR ft_ftid = _ftid)
     AND (_foid IS NULL OR ft_foid = _foid)
     AND (_usid IS NULL OR ft_usid = _usid);
END;;

delimiter ;
