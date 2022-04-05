DROP procedure IF EXISTS userimages_insert;

delimiter ;;

CREATE PROCEDURE userimages_insert(
  IN _usid       int(11),
  IN _width      int(11),
  IN _height     int(11),
  IN _size       int(11),
  IN _filename   varchar(100),
  IN _type       varchar(10)
)
BEGIN
  INSERT INTO userimages (
    ui_usid, ui_width, ui_height, ui_size, ui_filename, ui_type, ui_dla
  ) VALUES (
    _usid, _width, _height, _size, _filename, _type, CURRENT_TIMESTAMP
  );

  CALL userimages_get_by_ids(LAST_INSERT_ID());
END;;

delimiter ;
