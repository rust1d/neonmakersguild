DROP procedure IF EXISTS blogtextblocks_insert;

delimiter ;;

CREATE PROCEDURE blogtextblocks_insert(
  IN _blog     int(11),
  IN _label    varchar(100),
  IN _body     longtext
)
BEGIN

  INSERT INTO blogtextblocks (
    btb_blog, btb_label, btb_body
  ) VALUES (
    _blog, _label, _body
  );

  CALL blogtextblocks_get_by_ids(LAST_INSERT_ID());
END;;

delimiter ;
