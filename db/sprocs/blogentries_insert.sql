DROP procedure IF EXISTS blogentries_insert;

delimiter ;;

CREATE PROCEDURE blogentries_insert(
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

  INSERT INTO blogentries (
    ben_blog, ben_usid, ben_title, ben_body, ben_posted, ben_morebody, ben_alias, ben_allowcomments, ben_attachment, ben_filesize, ben_mimetype, ben_views, ben_released, ben_mailed
  ) VALUES (
    _blog, _usid, _title, _body, _posted, _morebody, _alias, _allowcomments, _attachment, _filesize, _mimetype, _views, _released, _mailed
  );

  CALL blogentries_get_by_ids(LAST_INSERT_ID());
END;;

delimiter ;
