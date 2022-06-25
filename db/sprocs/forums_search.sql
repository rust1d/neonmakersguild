DROP procedure IF EXISTS forums_search;

delimiter ;;

CREATE PROCEDURE forums_search(
  IN _foid        int(11),
  IN _alias       varchar(50),
  IN _admin       tinyint
)
BEGIN
  SELECT *
    FROM forums
   WHERE (_foid IS NULL OR fo_foid = _foid)
     AND (_alias IS NULL OR fo_alias = CONVERT(_alias USING utf8))
     AND (_admin IS NULL OR fo_admin = _admin)
   ORDER BY fo_order;
END;;

delimiter ;
