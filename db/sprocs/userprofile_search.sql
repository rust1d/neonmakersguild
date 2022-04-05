DROP procedure IF EXISTS userprofile_search;

delimiter ;;

CREATE PROCEDURE userprofile_search(
  IN _upid   int(11),
  IN _usid   int(11)
)
BEGIN
  SELECT *
    FROM userprofile
   WHERE (_upid IS NULL OR up_upid = _upid)
     AND (_usid IS NULL OR up_usid = _usid);
END;;

delimiter ;
