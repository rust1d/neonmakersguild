DROP procedure IF EXISTS forumimages_insert;

delimiter ;;

CREATE PROCEDURE forumimages_insert(
  IN _foid          INT(11),
  IN _ftid          INT(11),
  IN _fmid          INT(11),
  IN _usid          INT(11),
  IN _width         INT(11),
  IN _height        INT(11),
  IN _size          INT(11),
  IN `_filename`    VARCHAR(100)
)
BEGIN

  INSERT INTO forumimages (
    fi_foid, fi_ftid, fi_fmid, fi_usid, fi_width, fi_height, fi_size, fi_filename, fi_added
  ) VALUES (
    _foid, _ftid, _fmid, _usid, _width, _height, _size, `_filename`, CURRENT_TIMESTAMP
  );

  CALL forumimages_get_by_ids(LAST_INSERT_ID());
END;;

delimiter ;
