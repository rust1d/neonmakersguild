DROP procedure IF EXISTS users_update;

delimiter ;;

CREATE PROCEDURE users_update(
  IN _usid          int(11),
  IN _user          varchar(50),
  IN _password      varchar(100),
  IN _email         varchar(50),
  IN _permissions   tinyint(4),
  IN _renewal       date,
  IN _deleted       datetime
)
BEGIN
  UPDATE users
     SET us_user        = IFNULL(_user,        us_user),
         us_password    = IFNULL(_password,    us_password),
         us_email       = IFNULL(_email,       us_email),
         us_permissions = IFNULL(_permissions, us_permissions),
         us_deleted     = IFNULL(_deleted,     us_deleted),
         us_renewal     = IFNULL(_renewal,     us_renewal),
         us_dla         = CURRENT_TIMESTAMP
   WHERE us_usid = _usid;

  CALL users_get_by_ids(_usid);
END;;

delimiter ;
