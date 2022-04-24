DROP procedure IF EXISTS blogsubscribers_update;

delimiter ;;

CREATE PROCEDURE blogsubscribers_update(
  IN _bsuid       int(11),
  IN _blog        int(11),
  IN _email       varchar(50),
  IN _verified    tinyint(1)
)
BEGIN
  UPDATE blogsubscribers
     SET bsu_blog     = IFNULL(_blog,      bsu_blog),
         bsu_email    = IFNULL(_email,     bsu_email),
         bsu_verified = IFNULL(_verified,  bsu_verified)
   WHERE bsu_bsuid = _bsuid;

  CALL blogsubscribers_get_by_ids(_bsuid);
END;;

delimiter ;
