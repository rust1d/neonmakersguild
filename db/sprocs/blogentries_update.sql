DROP procedure IF EXISTS blogentries_update;

delimiter ;;

CREATE PROCEDURE blogentries_update(
  IN _benid            int(11),
  IN _blog             int(11),
  IN _usid             int(11),
  IN _title            varchar(100),
  IN _body             longtext,
  IN _posted           datetime,
  IN _morebody         longtext,
  IN _alias            varchar(100),
  IN _allowcomments    tinyint(1),
  IN _attachment       varchar(255),
  IN _filesize         int(11) unsigned,
  IN _mimetype         varchar(255),
  IN _views            int(11) unsigned,
  IN _released         tinyint(1),
  IN _mailed           tinyint(1)
)
BEGIN
  UPDATE blogentries
     SET ben_blog          = IFNULL(_blog,           ben_blog),
         ben_usid          = IFNULL(_usid,           ben_usid),
         ben_title         = IFNULL(_title,          ben_title),
         ben_body          = IFNULL(_body,           ben_body),
         ben_posted        = IFNULL(_posted,         ben_posted),
         ben_morebody      = IFNULL(_morebody,       ben_morebody),
         ben_alias         = IFNULL(_alias,          ben_alias),
         ben_allowcomments = IFNULL(_allowcomments,  ben_allowcomments),
         ben_attachment    = IFNULL(_attachment,     ben_attachment),
         ben_filesize      = IFNULL(_filesize,       ben_filesize),
         ben_mimetype      = IFNULL(_mimetype,       ben_mimetype),
         ben_views         = IFNULL(_views,          ben_views),
         ben_released      = IFNULL(_released,       ben_released),
         ben_mailed        = IFNULL(_mailed,         ben_mailed)
   WHERE ben_benid = _benid;

  CALL blogentries_get_by_ids(_benid);
END;;

delimiter ;
