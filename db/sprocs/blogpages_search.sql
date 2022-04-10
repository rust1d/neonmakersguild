DROP procedure IF EXISTS blogpages_search;

delimiter ;;

CREATE PROCEDURE blogpages_search(
  IN _bpaid    int(11),
  IN _blog     int(11),
  IN _title    varchar(100),
  IN _alias    varchar(100)
)
BEGIN
  SELECT blogpages.*, us_user AS bpa_blogname
    FROM blogpages
         INNER JOIN users ON us_usid = bpa_blog
   WHERE (_bpaid IS NULL OR bpa_bpaid = _bpaid)
     AND (_blog IS NULL OR bpa_blog = _blog)
     AND (_title IS NULL OR bpa_title = _title)
     AND (_alias IS NULL OR bpa_alias = _alias);
END;;

delimiter ;
