DROP procedure IF EXISTS userprofile_insert;

delimiter ;;

CREATE PROCEDURE userprofile_insert(
  IN _usid        int(11),
  IN _firstname   varchar(50),
  IN _lastname    varchar(50),
  IN _bio         text,
  IN _location    varchar(100)
)
BEGIN
  INSERT INTO userprofile (
    up_usid, up_firstname, up_lastname, up_bio, up_location, up_dla
  ) VALUES (
    _usid, _firstname, _lastname, _bio, _location, CURRENT_TIMESTAMP
  );

  CALL userprofile_get_by_ids(LAST_INSERT_ID());
END;;

delimiter ;
