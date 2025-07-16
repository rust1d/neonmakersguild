DROP procedure IF EXISTS users_recently_joining;

delimiter ;;

CREATE PROCEDURE users_recently_joining(
  IN _limit INT(11)
)
BEGIN
  SELECT *
    FROM users
   ORDER BY us_usid DESC
   LIMIT _limit;
END;;

delimiter ;
