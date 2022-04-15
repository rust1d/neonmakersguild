DROP procedure IF EXISTS blogsubscribers_insert;

delimiter ;;

CREATE PROCEDURE blogsubscribers_insert(
  IN _email       varchar(50),
  IN _token       varchar(35),
  IN _blog        int(11),
  IN _verified    tinyint(1)
)
BEGIN

  INSERT INTO blogsubscribers (
    bsu_email, bsu_token, bsu_blog, bsu_verified
  ) VALUES (
    _email, _token, _blog, _verified
  );

  CALL blogsubscribers_get_by_ids(LAST_INSERT_ID());
END;;

delimiter ;
