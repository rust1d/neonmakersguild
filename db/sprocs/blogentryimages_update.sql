DROP procedure IF EXISTS blogentryimages_update;

delimiter ;;

CREATE PROCEDURE blogentryimages_update(
  IN _beiid         INT(11),
  IN _benid         INT(11),
  IN _uiid          INT(11),
  IN _caption       VARCHAR(2000)
)
BEGIN
  UPDATE blogentryimages
     SET bei_benid      = IFNULL(_benid,       bei_benid),
         bei_uiid       = IFNULL(_uiid,        bei_uiid),
         bei_caption    = IFNULL(_caption,     bei_caption),
         bei_dla        = CURRENT_TIMESTAMP
   WHERE bei_beiid = _beiid;

  CALL blogentryimages_get_by_ids(_beiid);
END;;

delimiter ;
