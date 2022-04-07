DROP procedure IF EXISTS blogroles_update;

delimiter ;;

CREATE PROCEDURE blogroles_update(
  IN _broid          int(11),
  IN _role           varchar(50),
  IN _description    varchar(255)
)
BEGIN
  UPDATE blogroles
     SET bro_role        = IFNULL(_role,         bro_role),
         bro_description = IFNULL(_description,  bro_description)
   WHERE bro_broid = _broid;

  CALL blogroles_get_by_ids(_broid);
END;;

delimiter ;
