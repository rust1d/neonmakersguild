DROP procedure IF EXISTS blogtextblocks_insert;

delimiter ;;

CREATE PROCEDURE blogtextblocks_insert(
  IN _label    varchar(100),
  IN _body     longtext,
  IN _blog     int(11)
)
BEGIN

  INSERT INTO blogtextblocks (
    btb_label, btb_body, btb_blog
  ) VALUES (
    _label, _body, _blog
  );

  CALL blogtextblocks_get_by_ids(LAST_INSERT_ID());
END;;

delimiter ;
