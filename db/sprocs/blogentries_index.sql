DROP procedure IF EXISTS blogentries_index;

delimiter ;;

CREATE PROCEDURE blogentries_index()
BEGIN
  SELECT ben_benid, ben_usid,
         IF(ben_blog = 1 OR ben_promoted < CURRENT_TIMESTAMP, 1, 0) AS ben_frontpage,
         GROUP_CONCAT(bei_beiid) AS ben_beiids
    FROM blogentries
         LEFT OUTER JOIN blogentryimages ON bei_benid = ben_benid
   WHERE ben_released = 1
     AND ben_posted < CURRENT_TIMESTAMP
   GROUP BY ben_benid;

   /* SELECT ben_usid, group_concat(distinct ben_benid order by ben_posted), group_concat(bei_beiid order by ben_posted, bei_beiid)
     FROM blogentries
          LEFT OUTER JOIN blogentryimages ON bei_benid = ben_benid
    GROUP BY ben_usid; */

END;;

delimiter ;
