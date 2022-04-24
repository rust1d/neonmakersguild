DROP procedure IF EXISTS blogsubscribers_insert;

delimiter ;;

CREATE PROCEDURE blogsubscribers_insert(
  IN _blog        int(11),
  IN _email       varchar(50),
  IN _verified    tinyint(1)
)
BEGIN

  INSERT INTO blogsubscribers (
    bsu_blog, bsu_email, bsu_verified
  ) VALUES (
    _blog, _email, _verified
  );

  CALL blogsubscribers_get_by_ids(LAST_INSERT_ID());
END;;

delimiter ;
