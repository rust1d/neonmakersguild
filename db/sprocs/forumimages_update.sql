DROP procedure IF EXISTS forumimages_update;

delimiter ;;

CREATE PROCEDURE forumimages_update(
  IN _fiid          INT(11),
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
  UPDATE forumimages
     SET fi_foid        = IFNULL(_foid,        fi_foid),
         fi_ftid        = IFNULL(_ftid,        fi_ftid),
         fi_fmid        = IFNULL(_fmid,        fi_fmid),
         fi_usid        = IFNULL(_usid,        fi_usid),
         fi_width       = IFNULL(_width,       fi_width),
         fi_height      = IFNULL(_height,      fi_height),
         fi_size        = IFNULL(_size,        fi_size),
         fi_filename    = IFNULL(`_filename`,  fi_filename)
   WHERE fi_fiid = _fiid;

  CALL forumimages_get_by_ids(_fiid);
END;;

delimiter ;
