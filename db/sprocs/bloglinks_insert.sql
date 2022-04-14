DROP procedure IF EXISTS bloglinks_insert;

delimiter ;;

CREATE PROCEDURE bloglinks_insert(
  IN _blog     int(11),
  IN _url      varchar(200),
  IN _title    varchar(100),
  IN _type     varchar(15)
)
BEGIN

  INSERT INTO bloglinks (
    bli_blog, bli_url, bli_title, bli_type
  ) VALUES (
    _blog, _url, _title, _type
  );

  CALL bloglinks_get_by_ids(LAST_INSERT_ID());
END;;

delimiter ;
