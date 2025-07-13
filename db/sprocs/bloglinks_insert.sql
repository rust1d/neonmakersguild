DROP procedure IF EXISTS bloglinks_insert;

delimiter ;;

CREATE PROCEDURE bloglinks_insert(
  IN _blog           int(11),
  IN _type           varchar(20),
  IN _url            varchar(200),
  IN _title          varchar(100),
  IN _description    varchar(200),
  IN _clicks         int(11)
)
BEGIN

  INSERT INTO bloglinks (
    bli_blog, bli_type, bli_url, bli_title, bli_description, bli_clicks, bli_added, bli_dla
  ) VALUES (
    _blog, _type, _url, _title, _description, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
  );

  CALL bloglinks_get_by_ids(LAST_INSERT_ID());
END;;

delimiter ;
