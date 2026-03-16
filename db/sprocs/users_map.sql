DROP procedure IF EXISTS users_map;

delimiter ;;

CREATE PROCEDURE users_map()
BEGIN
  SELECT us_usid, us_user, up_firstname, up_lastname, up_location, up_latitude, up_longitude
    FROM users
         INNER JOIN userprofile ON up_usid = us_usid
   WHERE us_deleted IS NULL
     AND up_latitude IS NOT NULL
     AND up_longitude IS NOT NULL
   ORDER BY us_user;
END;;

delimiter ;
