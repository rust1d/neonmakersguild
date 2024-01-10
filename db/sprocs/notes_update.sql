DROP procedure IF EXISTS notes_update;

delimiter ;;

CREATE PROCEDURE notes_update(
  IN _noid     int(11) unsigned,
  IN _usid     int(11),
  IN _note     varchar(2000),
  IN _poster   varchar(50)
)
BEGIN
  UPDATE notes
     SET no_usid   = IFNULL(_usid,   no_usid),
         no_note   = IFNULL(_note,   no_note),
         no_poster = IFNULL(_poster, no_poster),
         no_dla  =   CURRENT_TIMESTAMP
   WHERE no_noid = _noid;

  CALL notes_get_by_ids(_noid);
END;;

delimiter ;
