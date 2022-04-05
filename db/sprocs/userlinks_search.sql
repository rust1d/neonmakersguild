DROP procedure IF EXISTS userlinks_search;

delimiter ;;

CREATE PROCEDURE userlinks_search(
  IN _ulid   int(11),
  IN _usid   int(11)
)
BEGIN
  SELECT *
    FROM userlinks
   WHERE (_ulid IS NULL OR ul_ulid = _ulid)
     AND (_usid IS NULL OR ul_usid = _usid);
END;;

delimiter ;
