DROP procedure IF EXISTS forummessages_update;

delimiter ;;

CREATE PROCEDURE forummessages_update(
  IN _fmid         int(11),
  IN _foid         int(11),
  IN _ftid         int(11),
  IN _usid         int(11),
  IN _body         text,
  IN _history      text,
  IN _deleted_by   int(11),
  IN _deleted      datetime
)
BEGIN
  UPDATE forummessages
     SET fm_foid       = IFNULL(_foid,       fm_foid),
         fm_ftid       = IFNULL(_ftid,       fm_ftid),
         fm_usid       = IFNULL(_usid,       fm_usid),
         fm_body       = IFNULL(_body,       fm_body),
         fm_history    = IFNULL(_history,    fm_history),
         fm_deleted_by = IFNULL(_deleted_by, fm_deleted_by),
         fm_deleted    = IFNULL(_deleted,    fm_deleted),
         fm_dla        = CURRENT_TIMESTAMP
   WHERE fm_fmid = _fmid;

  CALL forummessages_get_by_ids(_fmid);
END;;

delimiter ;
