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
  IN _promo       varchar(25)
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
         up_dla       = CURRENT_TIMESTAMP
   WHERE up_upid = _upid;

  CALL userprofile_get_by_ids(_upid);
END;;

delimiter ;
