DROP procedure IF EXISTS memberrequests_insert;

delimiter ;;

CREATE PROCEDURE memberrequests_insert(
  IN _firstname    varchar(50),
  IN _lastname     varchar(50),
  IN _email        varchar(50),
  IN _phone        varchar(15),
  IN _location     varchar(100),
  IN _address1     varchar(50),
  IN _address2     varchar(25),
  IN _city         varchar(25),
  IN _region       varchar(25),
  IN _postal       varchar(12),
  IN _country      varchar(2),
  IN _website1     varchar(200),
  IN _website2     varchar(200),
  IN _history      text,
  IN _promo        varchar(25),
  IN _hearabout    varchar(200),
  IN _user         varchar(50),
  IN _usid         int(11),
  IN _deleted_by   int(11),
  IN _deleted      datetime,
  IN _validated    datetime,
  IN _accepted     datetime
)
BEGIN
  INSERT INTO memberrequests (
    mr_firstname, mr_lastname, mr_email, mr_phone, mr_location, mr_address1, mr_address2, mr_city,
    mr_region, mr_postal, mr_country, mr_website1, mr_website2, mr_history, mr_promo, mr_hearabout,
    mr_user, mr_usid, mr_deleted_by, mr_deleted, mr_validated, mr_accepted,
    mr_added, mr_dla
  ) VALUES (
    _firstname, _lastname, _email, _phone, _location, _address1, _address2, _city,
    _region, _postal, _country, _website1, _website2, _history, _promo, _hearabout,
    _user, _usid, _deleted_by, _deleted, _validated, _accepted,
    CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
  );

  CALL memberrequests_get_by_ids(LAST_INSERT_ID());
END;;

delimiter ;
