DROP procedure IF EXISTS users_recently_posting;

delimiter ;;

CREATE PROCEDURE users_recently_posting(
  IN _limit INT(11)
)
BEGIN
  SELECT users.* , ben_posted, ben_blog, ben_benid,max_posted
    FROM users
         INNER JOIN (
           SELECT ben_usid AS max_usid, MAX(ben_posted) AS max_posted
             FROM blogentries
            WHERE ben_released = 1
              AND ben_posted < CURRENT_TIMESTAMP
            GROUP BY ben_usid
         ) AS maxpost ON max_usid = us_usid
         INNER JOIN blogentries AS latest ON ben_usid = max_usid AND ben_posted = max_posted
   ORDER BY IF(ben_blog=1, 1, 0), max_posted DESC
   LIMIT _limit;
END;;

delimiter ;
