DROP procedure IF EXISTS forums_list;

delimiter ;;

CREATE PROCEDURE forums_list(
  IN _foid        int(11),
  IN _alias       varchar(50),
  IN _admin       tinyint
)
BEGIN
  SELECT *
    FROM forums
         LEFT OUTER JOIN forummessages ON fm_fmid = fo_last_fmid
         LEFT OUTER JOIN forumthreads ON ft_ftid = fm_ftid
         LEFT OUTER JOIN users ON us_usid = fm_usid
   WHERE (_foid IS NULL OR fo_foid = _foid)
     AND (_alias IS NULL OR fo_alias = CONVERT(_alias USING utf8))
     AND (_admin IS NULL OR fo_admin = _admin)
   ORDER BY fo_order;
END;;

delimiter ;
