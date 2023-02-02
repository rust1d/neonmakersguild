DROP procedure IF EXISTS userprofile_insert;

delimiter ;;

CREATE PROCEDURE userprofile_insert(
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
  INSERT INTO userprofile (
    up_usid, up_firstname, up_lastname, up_bio, up_location, up_phone, up_promo, up_address1, up_address2, up_city, up_region, up_postal, up_country, up_dla
  ) VALUES (
    _usid, _firstname, _lastname, _bio, _location, _phone, _promo, _address1, _address2, _city, _region, _postal, _country, CURRENT_TIMESTAMP
  );

  CALL userprofile_get_by_ids(LAST_INSERT_ID());
END;;

delimiter ;
