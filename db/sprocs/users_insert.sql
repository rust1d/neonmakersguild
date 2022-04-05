DROP procedure IF EXISTS users_insert;

delimiter ;;

CREATE PROCEDURE users_insert(
  IN _email         varchar(50),
  IN _password      varchar(100),
  IN _permissions   tinyint(4),
  IN _active        tinyint(1),
  IN _deleted       tinyint(1)
)
BEGIN
  SET _permissions = IFNULL(_permissions, 0);
  SET _active = IFNULL(_active, 1);
  SET _deleted = IFNULL(_deleted, 0);

  INSERT INTO users (
    us_email, us_password, us_permissions, us_active, us_deleted, us_added, us_dla
  ) VALUES (
    _email, _password, _permissions, _active, _deleted, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
  );

  CALL users_get_by_ids(LAST_INSERT_ID());
END;;

delimiter ;
