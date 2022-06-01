DROP procedure IF EXISTS blogentries_update;

delimiter ;;

CREATE PROCEDURE blogentries_update(
  IN _benid       int(11),
  IN _blog        int(11),
  IN _usid        int(11),
  IN _posted      datetime,
  IN _title       varchar(100),
  IN _alias       varchar(100),
  IN _image       varchar(150),
  IN _body        longtext,
  IN _morebody    longtext,
  IN _comments    tinyint(1),
  IN _views       int(11) unsigned,
  IN _released    tinyint(1),
  IN _promoted    datetime
)
BEGIN
  UPDATE blogentries
     SET ben_blog     = IFNULL(_blog,      ben_blog),
         ben_usid     = IFNULL(_usid,      ben_usid),
         ben_posted   = IFNULL(_posted,    ben_posted),
         ben_title    = IFNULL(_title,     ben_title),
         ben_alias    = IFNULL(_alias,     ben_alias),
         ben_image    = IFNULL(_image,     ben_image),
         ben_body     = IFNULL(_body,      ben_body),
         ben_morebody = IFNULL(_morebody,  ben_morebody),
         ben_comments = IFNULL(_comments,  ben_comments),
         ben_views    = IFNULL(_views,     ben_views),
         ben_released = IFNULL(_released,  ben_released),
         ben_promoted = IFNULL(_promoted,  ben_promoted),
         ben_dla      = CURRENT_TIMESTAMP
   WHERE ben_benid = _benid;

  CALL blogentries_get_by_ids(_benid);
END;;

delimiter ;
