DROP procedure IF EXISTS blogsubscribers_search;

delimiter ;;

CREATE PROCEDURE blogsubscribers_search(
  IN _bsuid       int(11),
  IN _email       varchar(50),
  IN _token       varchar(35),
  IN _blog        int(11),
  IN _verified    tinyint(1)
)
BEGIN
  SELECT *
    FROM blogsubscribers
   WHERE (_bsuid IS NULL OR bsu_bsuid = _bsuid)
     AND (_email IS NULL OR bsu_email = _email)
     AND (_token IS NULL OR bsu_token = _token)
     AND (_blog IS NULL OR bsu_blog = _blog)
     AND (_verified IS NULL OR bsu_verified = _verified);
END;;

delimiter ;
