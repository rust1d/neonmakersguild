DROP procedure IF EXISTS user_counts;

delimiter ;;

CREATE PROCEDURE user_counts(
  IN _usid     INT(11)
)
BEGIN
  SELECT
    (SELECT COUNT(*) FROM blogcomments WHERE bco_usid = us_usid) AS comment_cnt,
    (SELECT COUNT(*) FROM blogentries WHERE ben_usid = us_usid AND ben_released=1) AS post_cnt,
    (SELECT COUNT(*) FROM bloglinks WHERE bli_blog = us_usid AND bli_type='bookmark') AS link_cnt,
    (SELECT COUNT(*) FROM userimages WHERE ui_usid = us_usid) AS image_cnt,
    (SELECT COUNT(*) FROM forumMessages WHERE fm_usid = us_usid AND fm_deleted IS NULL) AS message_cnt,
    (SELECT COUNT(*) FROM forumThreads WHERE ft_usid = us_usid AND ft_deleted IS NULL) AS  thread_cnt
  FROM users
  WHERE us_usid=_usid;
END;;

delimiter ;
