DROP procedure IF EXISTS forumthreads_update;

delimiter ;;

CREATE PROCEDURE forumthreads_update(
  IN _ftid          int(11),
  IN _foid          int(11),
  IN _usid          int(11),
  IN _subject       varchar(100),
  IN _alias         varchar(100),
  IN _sticky        tinyint(1),
  IN _locked        tinyint(1),
  IN _messages      int(11),
  IN _views         int(11),
  IN _last_fmid     int(11),
  IN _deleted_by    int(11),
  IN _deleted       datetime
)
BEGIN
  UPDATE forumthreads
     SET ft_foid        = IFNULL(_foid,        ft_foid),
         ft_usid        = IFNULL(_usid,        ft_usid),
         ft_subject     = IFNULL(_subject,     ft_subject),
         ft_alias       = IFNULL(_alias,       ft_alias),
         ft_sticky      = IFNULL(_sticky,      ft_sticky),
         ft_locked      = IFNULL(_locked,      ft_locked),
         ft_messages    = IFNULL(_messages,    ft_messages),
         ft_views       = IFNULL(_views,       ft_views),
         ft_last_fmid   = IFNULL(_last_fmid,   ft_last_fmid),
         ft_deleted_by  = IFNULL(_deleted_by,  ft_deleted_by),
         ft_deleted     = IFNULL(_deleted,     ft_deleted),
         ft_dla         = CURRENT_TIMESTAMP
   WHERE ft_ftid = _ftid;

  CALL forumthreads_get_by_ids(_ftid);
END;;

delimiter ;
