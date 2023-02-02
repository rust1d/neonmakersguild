DROP procedure IF EXISTS userprofile_update;

delimiter ;;

CREATE PROCEDURE userprofile_update(
  IN _upid        int(11),
  IN _usid        int(11),
  IN _firstname   varchar(50),
  IN _lastname    varchar(50),
  IN _bio         text,
  IN _location    varchar(100),
  IN _phone       varchar(15),
  IN _promo       varchar(25),
  IN _address1    varchar(50),
  IN _address2    varchar(25),
  IN _city        varchar(25),
  IN _region      varchar(25),
  IN _postal      varchar(12),
  IN _country     varchar(2)
)
BEGIN
  UPDATE userprofile
     SET up_usid      = IFNULL(_usid,      up_usid),
         up_firstname = IFNULL(_firstname, up_firstname),
         up_lastname  = IFNULL(_lastname,  up_lastname),
         up_bio       = IFNULL(_bio,       up_bio),
         up_location  = IFNULL(_location,  up_location),
         up_phone     = IFNULL(_phone,     up_phone),
         up_promo     = IFNULL(_promo,     up_promo),
         up_address1  = IFNULL(_address1,  up_address1),
         up_address2  = IFNULL(_address2,  up_address2),
         up_city      = IFNULL(_city,      up_city),
         up_region    = IFNULL(_region,    up_region),
         up_postal    = IFNULL(_postal,    up_postal),
         up_country   = IFNULL(_country,   up_country),
         up_dla       = CURRENT_TIMESTAMP
   WHERE up_upid = _upid;

  CALL userprofile_get_by_ids(_upid);
END;;

delimiter ;
