DROP procedure IF EXISTS users_insert;

delimiter ;;

CREATE PROCEDURE users_insert(
  IN _user          varchar(50),
  IN _password      varchar(100),
  IN _email         varchar(50),
  IN _permissions   tinyint(4),
  IN _renewal       date,
  IN _deleted       datetime
)
BEGIN
  SET _permissions = IFNULL(_permissions, 0);
  SET _renewal = DATE_ADD(DATE_FORMAT(CURRENT_TIMESTAMP, '%Y-%m-01'), INTERVAL 1 MONTH);

  INSERT INTO users (
    us_user, us_password, us_email, us_permissions, us_renewal, us_deleted, us_added, us_dla, us_dll
  ) VALUES (
    _user, _password, _email, _permissions, _renewal, _deleted, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
  );

  CALL users_get_by_ids(LAST_INSERT_ID());
END;;

delimiter ;
