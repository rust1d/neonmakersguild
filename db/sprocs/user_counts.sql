DROP procedure IF EXISTS user_counts;

delimiter ;;

CREATE PROCEDURE user_counts(
  IN _usid     INT(11)
)
BEGIN
  DECLARE _past_date DATE DEFAULT DATE_ADD(CURRENT_TIMESTAMP, INTERVAL -30 DAY);

  SELECT
    (SELECT COUNT(*) FROM blogentries WHERE ben_blog = us_usid AND ben_released = 1) AS post_cnt,
    (SELECT COUNT(*) FROM bloglinks WHERE bli_blog = us_usid AND bli_type = 'bookmark') AS link_cnt,
    (SELECT COUNT(*) FROM userimages WHERE ui_usid = us_usid) AS image_cnt,
    -- (SELECT COUNT(*) FROM blogcomments WHERE bco_usid = us_usid) AS comment_cnt,
    -- (SELECT COUNT(*) FROM forumThreads WHERE ft_usid = us_usid AND ft_deleted IS NULL) AS  thread_cnt,
    -- (SELECT COUNT(*) FROM forumMessages WHERE fm_usid = us_usid AND fm_deleted IS NULL) AS message_cnt,
    (SELECT COUNT(*) FROM blogentries WHERE ben_usid = us_usid AND ben_released = 1 AND ben_dla > _past_date) AS recent_post_cnt,
    (SELECT COUNT(*) FROM blogcomments WHERE bco_usid = us_usid AND bco_dla > _past_date) AS recent_comment_cnt,
    (SELECT COUNT(*) FROM forumThreads INNER JOIN forums ON fo_foid = ft_foid AND fo_admin = 0 WHERE ft_usid = us_usid AND ft_deleted IS NULL AND ft_dla > _past_date) AS recent_thread_cnt,
    (SELECT COUNT(*) FROM forumMessages INNER JOIN forums ON fo_foid = fm_foid AND fo_admin = 0 WHERE fm_usid = us_usid AND fm_deleted IS NULL AND fm_dla > _past_date) AS recent_message_cnt
  FROM users
  WHERE us_usid=_usid;
END;;

delimiter ;
