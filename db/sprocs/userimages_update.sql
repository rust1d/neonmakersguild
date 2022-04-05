DROP procedure IF EXISTS userimages_update;

delimiter ;;

CREATE PROCEDURE userimages_update(
  IN _uiid       int(11),
  IN _usid       int(11),
  IN _width      int(11),
  IN _height     int(11),
  IN _size       int(11),
  IN _filename   varchar(100),
  IN _type       varchar(10)
)
BEGIN
  UPDATE userimages
     SET ui_usid     = IFNULL(_usid,     ui_usid),
         ui_width    = IFNULL(_width,    ui_width),
         ui_height   = IFNULL(_height,   ui_height),
         ui_size     = IFNULL(_size,     ui_size),
         ui_filename = IFNULL(_filename, ui_filename),
         ui_type     = IFNULL(_type,     ui_type),
         ui_dla      = CURRENT_TIMESTAMP
   WHERE ui_uiid = _uiid;

  CALL userimages_get_by_ids(_uiid);
END;;

delimiter ;
