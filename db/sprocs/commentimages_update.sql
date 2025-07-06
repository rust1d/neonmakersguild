DROP procedure IF EXISTS commentimages_update;

delimiter ;;

CREATE PROCEDURE commentimages_update(
  IN _ciid          INT(11),
  IN _bcoid         INT(11),
  IN _benid         INT(11),
  IN _beiid         INT(11),
  IN _usid          INT(11),
  IN _width         INT(11),
  IN _height        INT(11),
  IN _size          INT(11),
  IN _filename      VARCHAR(100)
)
BEGIN
  UPDATE commentimages
     SET ci_bcoid       = IFNULL(_bcoid,       ci_bcoid),
         ci_benid       = IFNULL(_benid,       ci_benid),
         ci_beiid       = IFNULL(_beiid,       ci_beiid),
         ci_usid        = IFNULL(_usid,        ci_usid),
         ci_width       = IFNULL(_width,       ci_width),
         ci_height      = IFNULL(_height,      ci_height),
         ci_size        = IFNULL(_size,        ci_size),
         ci_filename    = IFNULL(_filename,    ci_filename)
   WHERE ci_ciid = _ciid;

  CALL commentimages_get_by_ids(_ciid);
END;;

delimiter ;
