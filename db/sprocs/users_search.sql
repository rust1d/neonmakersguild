DROP procedure IF EXISTS users_search;

delimiter ;;

CREATE PROCEDURE users_search(
  IN _usid     int(11),
  IN _email    varchar(50)
)
BEGIN
  SELECT *
    FROM users
   WHERE (_usid IS NULL OR us_usid = _usid)
     AND (_email IS NULL OR us_email = CONVERT(_email USING latin1));
END;;

delimiter ;
