DROP procedure IF EXISTS blogpages_insert;

delimiter ;;

CREATE PROCEDURE blogpages_insert(
  IN _blog          int(11),
  IN _title         varchar(100),
  IN _alias         varchar(100),
  IN _body          longtext,
  IN _standalone    tinyint(1)
)
BEGIN
  SET _standalone = IFNULL(_standalone, 0);

  INSERT INTO blogpages (
    bpa_blog, bpa_title, bpa_alias, bpa_body, bpa_standalone
  ) VALUES (
    _blog, _title, _alias, _body, _standalone
  );

  CALL blogpages_get_by_ids(LAST_INSERT_ID());
END;;

delimiter ;
