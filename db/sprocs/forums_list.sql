DROP procedure IF EXISTS forums_list;

delimiter ;;

CREATE PROCEDURE forums_list(
  IN _admin       tinyint
)
BEGIN
  SELECT *
    FROM forums
         LEFT OUTER JOIN forummessages ON fm_fmid = fo_last_fmid
         LEFT OUTER JOIN forumthreads ON ft_ftid = fm_ftid
         LEFT OUTER JOIN users ON us_usid = fm_usid
   WHERE (_admin IS NULL OR fo_admin = _admin)
   ORDER BY fo_order;
END;;

delimiter ;
