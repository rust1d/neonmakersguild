DROP procedure IF EXISTS commentimages_insert;

delimiter ;;

CREATE PROCEDURE commentimages_insert(
  IN _bcoid         INT(11),
  IN _benid         INT(11),
  IN _beiid         INT(11),
  IN _usid          INT(11),
  IN _width         INT(11),
  IN _height        INT(11),
  IN _size          INT(11),
  IN `_filename`    VARCHAR(100)
)
BEGIN

  INSERT INTO commentimages (
    ci_bcoid, ci_benid, ci_beiid, ci_usid, ci_width, ci_height, ci_size, ci_filename,
    ci_added
  ) VALUES (
    _bcoid, _benid, _beiid, _usid, _width, _height, _size, `_filename`,
    CURRENT_TIMESTAMP
  );

  CALL commentimages_get_by_ids(LAST_INSERT_ID());
END;;

delimiter ;
