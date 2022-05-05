DROP procedure IF EXISTS users_insert;

delimiter ;;

CREATE PROCEDURE users_insert(
  IN _user          varchar(50),
  IN _password      varchar(100),
  IN _email         varchar(50),
  IN _permissions   tinyint(4),
  IN _deleted       datetime
)
BEGIN
  SET _permissions = IFNULL(_permissions, 0);

  INSERT INTO users (
    us_user, us_password, us_email, us_permissions, us_deleted, us_added, us_dla, us_dll
  ) VALUES (
    _user, _password, _email, _permissions, _deleted, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
  );

  CALL users_get_by_ids(LAST_INSERT_ID());
END;;

delimiter ;
