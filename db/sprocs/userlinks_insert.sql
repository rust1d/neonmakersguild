DROP procedure IF EXISTS userlinks_insert;

delimiter ;;

CREATE PROCEDURE userlinks_insert(
  IN _usid   int(11),
  IN _url    varchar(200),
  IN _type   varchar(10)
)
BEGIN
  INSERT INTO userlinks (
    ul_usid, ul_url, ul_type, ul_dla
  ) VALUES (
    _usid, _url, _type, CURRENT_TIMESTAMP
  );

  CALL userlinks_get_by_ids(LAST_INSERT_ID());
END;;

delimiter ;
