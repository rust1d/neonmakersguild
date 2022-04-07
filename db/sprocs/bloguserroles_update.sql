DROP procedure IF EXISTS bloguserroles_update;

delimiter ;;

CREATE PROCEDURE bloguserroles_update(
  IN _burid    int(11),
  IN _usid     int(11),
  IN _broid    int(11),
  IN _blog     int(11)
)
BEGIN
  UPDATE bloguserroles
     SET bur_usid  = IFNULL(_usid,   bur_usid),
         bur_broid = IFNULL(_broid,  bur_broid),
         bur_blog  = IFNULL(_blog,   bur_blog)
   WHERE bur_burid = _burid;

  CALL bloguserroles_get_by_ids(_burid);
END;;

delimiter ;
