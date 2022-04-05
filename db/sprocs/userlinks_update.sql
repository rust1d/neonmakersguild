DROP procedure IF EXISTS userlinks_update;

delimiter ;;

CREATE PROCEDURE userlinks_update(
  IN _ulid   int(11),
  IN _usid   int(11),
  IN _url    varchar(200),
  IN _type   varchar(10)
)
BEGIN
  UPDATE userlinks
     SET ul_usid = IFNULL(_usid, ul_usid),
         ul_url  = IFNULL(_url,  ul_url),
         ul_type = IFNULL(_type, ul_type),
         ul_dla  = CURRENT_TIMESTAMP
   WHERE ul_ulid = _ulid;

  CALL userlinks_get_by_ids(_ulid);
END;;

delimiter ;
