DROP procedure IF EXISTS blogentry_recentusers;

delimiter ;;

CREATE PROCEDURE blogentry_recentusers(
  IN _limit INT(11)
)
BEGIN
  SELECT user.*, max(ben_added) AS us_posted
    FROM blogentries
         INNER JOIN users ON us_usid = ben_usid
   WHERE ben_blog > 1
  GROUP BY ben_usid
  ORDER BY 2 DESC
  LIMIT _limit;
END;;

delimiter ;
