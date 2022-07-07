DROP procedure IF EXISTS memberrequests_update;

delimiter ;;

CREATE PROCEDURE memberrequests_update(
  IN _mrid         int(11),
  IN _firstname    varchar(50),
  IN _lastname     varchar(50),
  IN _email        varchar(50),
  IN _phone        varchar(15),
  IN _location     varchar(100),
  IN _website1     varchar(200),
  IN _website2     varchar(200),
  IN _history      text,
  IN _promo        varchar(25),
  IN _user         varchar(50),
  IN _usid         int(11),
  IN _deleted_by   int(11),
  IN _deleted      datetime,
  IN _validated    datetime,
  IN _accepted     datetime
)
BEGIN
  UPDATE memberrequests
     SET mr_firstname  = IFNULL(_firstname,  mr_firstname),
         mr_lastname   = IFNULL(_lastname,   mr_lastname),
         mr_email      = IFNULL(_email,      mr_email),
         mr_phone      = IFNULL(_phone,      mr_phone),
         mr_location   = IFNULL(_location,   mr_location),
         mr_website1   = IFNULL(_website1,   mr_website1),
         mr_website2   = IFNULL(_website2,   mr_website2),
         mr_history    = IFNULL(_history,    mr_history),
         mr_promo      = IFNULL(_promo,      mr_promo),
         mr_user       = IFNULL(_user,       mr_user),
         mr_usid       = IFNULL(_usid,       mr_usid),
         mr_deleted_by = IFNULL(_deleted_by, mr_deleted_by),
         mr_deleted    = IFNULL(_deleted,    mr_deleted),
         mr_validated  = IFNULL(_validated,  mr_validated),
         mr_accepted   = IFNULL(_accepted,   mr_accepted),
         mr_dla        = CURRENT_TIMESTAMP
   WHERE mr_mrid = _mrid;

  CALL memberrequests_get_by_ids(_mrid);
END;;

delimiter ;
