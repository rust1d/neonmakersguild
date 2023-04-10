DROP procedure IF EXISTS forummessages_last_post;

delimiter ;;

CREATE PROCEDURE forummessages_last_post(
  IN _foid     INT(11),
  IN _ftid     INT(11),
  IN _usid     INT(11)
)
BEGIN
  SELECT forummessages.*, fo_alias, ft_alias, us_user
    FROM forummessages
         INNER JOIN forumThreads ON ft_ftid = fm_ftid
         INNER JOIN forums ON fo_foid = fm_foid
         INNER JOIN users ON us_usid = fm_usid
   WHERE fm_foid = _foid
     AND fm_ftid = _ftid
     AND fm_usid = _usid
     AND fm_deleted IS NULL
   ORDER BY fm_added DESC
   LIMIT 1;
END;;

delimiter ;
