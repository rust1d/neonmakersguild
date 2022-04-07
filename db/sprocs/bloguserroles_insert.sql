DROP procedure IF EXISTS bloguserroles_insert;

delimiter ;;

CREATE PROCEDURE bloguserroles_insert(
  IN _usid     int(11),
  IN _broid    int(11),
  IN _blog     int(11)
)
BEGIN

  INSERT INTO bloguserroles (
    bur_usid, bur_broid, bur_blog
  ) VALUES (
    _usid, _broid, _blog
  );

  CALL bloguserroles_get_by_ids(LAST_INSERT_ID());
END;;

delimiter ;
