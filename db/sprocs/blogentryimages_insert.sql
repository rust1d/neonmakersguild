DROP procedure IF EXISTS blogentryimages_insert;

delimiter ;;

CREATE PROCEDURE blogentryimages_insert(
  IN _benid         INT(11),
  IN _uiid          INT(11),
  IN _caption       VARCHAR(2000)
)
BEGIN

  INSERT INTO blogentryimages (
    bei_benid, bei_uiid, bei_caption, bei_added, bei_dla
  ) VALUES (
    _benid, _uiid, _caption, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
  );

  CALL blogentryimages_get_by_ids(LAST_INSERT_ID());
END;;

delimiter ;
