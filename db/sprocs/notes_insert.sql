DROP procedure IF EXISTS notes_insert;

delimiter ;;

CREATE PROCEDURE notes_insert(
  IN _usid     int(11),
  IN _note     varchar(2000),
  IN _poster   varchar(50)
)
BEGIN

  INSERT INTO notes (
    no_usid, no_note, no_poster, no_added, no_dla
  ) VALUES (
    _usid, _note, _poster, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
  );

  CALL notes_get_by_ids(LAST_INSERT_ID());
END;;

delimiter ;
