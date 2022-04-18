DROP procedure IF EXISTS blogentries_insert;

delimiter ;;

CREATE PROCEDURE blogentries_insert(
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
  IN _promoted    tinyint(1)
)
BEGIN

  INSERT INTO blogentries (
    ben_blog, ben_usid, ben_posted, ben_title, ben_alias, ben_image, ben_body, ben_morebody,
    ben_comments, ben_views, ben_released, ben_promoted
  ) VALUES (
    _blog, _usid, _posted, _title, _alias, _image, _body, _morebody,
    _comments, _views, _released, _promoted
  );

  CALL blogentries_get_by_ids(LAST_INSERT_ID());
END;;

delimiter ;
