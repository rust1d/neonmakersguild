DROP procedure IF EXISTS notes_search;

delimiter ;;

CREATE PROCEDURE notes_search(
  IN _noid   int(11) unsigned,
  IN _usid   int(11)
)
BEGIN
  SELECT *
    FROM notes
   WHERE (_noid IS NULL OR no_noid = _noid)
     AND (_usid IS NULL OR no_usid = _usid)
   ORDER BY no_added desc;
END;;

delimiter ;
