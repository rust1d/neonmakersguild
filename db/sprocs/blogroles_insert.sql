DROP procedure IF EXISTS blogroles_insert;

delimiter ;;

CREATE PROCEDURE blogroles_insert(
  IN _role           varchar(50),
  IN _description    varchar(255)
)
BEGIN

  INSERT INTO blogroles (
    bro_role, bro_description
  ) VALUES (
    _role, _description
  );

  CALL blogroles_get_by_ids(LAST_INSERT_ID());
END;;

delimiter ;
