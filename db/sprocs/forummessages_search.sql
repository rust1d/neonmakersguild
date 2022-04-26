DROP procedure IF EXISTS forummessages_search;

delimiter ;;

CREATE PROCEDURE forummessages_search(
  IN _fmid   int(11),
  IN _foid   int(11),
  IN _ftid   int(11),
  IN _usid   int(11)
)
BEGIN
  SELECT forummessages.*, fo_alias, ft_alias
    FROM forummessages
      INNER JOIN forumThreads ON ft_ftid = fm_ftid
      INNER JOIN forums ON fo_foid = fm_foid
   WHERE fm_deleted IS NULL
     AND (_fmid IS NULL OR fm_fmid = _fmid)
     AND (_foid IS NULL OR fm_foid = _foid)
     AND (_ftid IS NULL OR fm_ftid = _ftid)
     AND (_usid IS NULL OR fm_usid = _usid);
END;;

delimiter ;
