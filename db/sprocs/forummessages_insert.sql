DROP procedure IF EXISTS forummessages_insert;

delimiter ;;

CREATE PROCEDURE forummessages_insert(
  IN _foid         int(11),
  IN _ftid         int(11),
  IN _usid         int(11),
  IN _body         text,
  IN _history      text,
  IN _deleted_by   int(11),
  IN _deleted      datetime
)
BEGIN
  INSERT INTO forummessages (
    fm_foid, fm_ftid, fm_usid, fm_body, fm_history, fm_deleted_by, fm_deleted, fm_added, fm_dla
  ) VALUES (
    _foid, _ftid, _usid, _body, _history, _deleted_by, _deleted, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
  );

  CALL forummessages_get_by_ids(LAST_INSERT_ID());
END;;

delimiter ;
