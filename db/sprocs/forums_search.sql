DROP procedure IF EXISTS forums_search;

delimiter ;;

CREATE PROCEDURE forums_search(
  IN _foid        int(11),
  IN _alias       varchar(50)
)
BEGIN
  SELECT *
    FROM forums
   WHERE (_foid IS NULL OR fo_foid = _foid)
     AND (_alias IS NULL OR fo_alias = CONVERT(_alias USING utf8));
END;;

delimiter ;
