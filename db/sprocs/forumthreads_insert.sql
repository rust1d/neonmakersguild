DROP procedure IF EXISTS forumthreads_insert;

delimiter ;;

CREATE PROCEDURE forumthreads_insert(
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
  SET _sticky = IFNULL(_sticky, 0);
  SET _locked = IFNULL(_locked, 0);
  SET _messages = IFNULL(_messages, 0);
  SET _views = IFNULL(_views, 0);

  INSERT INTO forumthreads (
    ft_foid, ft_usid, ft_subject, ft_alias, ft_sticky, ft_locked, ft_messages, ft_views,
    ft_last_fmid, ft_deleted_by, ft_deleted, ft_added, ft_dla
  ) VALUES (
    _foid, _usid, _subject, _alias, _sticky, _locked, _messages, _views,
    _last_fmid, _deleted_by, _deleted, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
  );

  CALL forumthreads_get_by_ids(LAST_INSERT_ID());
END;;

delimiter ;
