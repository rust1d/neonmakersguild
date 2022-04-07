DROP procedure IF EXISTS bloguserroles_search;

delimiter ;;

CREATE PROCEDURE bloguserroles_search(
  IN _burid    int(11),
  IN _usid     int(11),
  IN _broid    int(11),
  IN _blog     int(11)
)
BEGIN
  SELECT *
    FROM bloguserroles
   WHERE (_burid IS NULL OR bur_burid = _burid)
     AND (_usid IS NULL OR bur_usid = _usid)
     AND (_broid IS NULL OR bur_broid = _broid)
     AND (_blog IS NULL OR bur_blog = _blog);
END;;

delimiter ;
