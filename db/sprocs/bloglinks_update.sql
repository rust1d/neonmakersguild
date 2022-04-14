DROP procedure IF EXISTS bloglinks_update;

delimiter ;;

CREATE PROCEDURE bloglinks_update(
  IN _bliid    int(11),
  IN _blog     int(11),
  IN _url      varchar(200),
  IN _title    varchar(100),
  IN _type     varchar(15)
)
BEGIN
  UPDATE bloglinks
     SET bli_blog  = IFNULL(_blog,   bli_blog),
         bli_url   = IFNULL(_url,    bli_url),
         bli_title = IFNULL(_title,  bli_title),
         bli_type  = IFNULL(_type,   bli_type)
   WHERE bli_bliid = _bliid;

  CALL bloglinks_get_by_ids(_bliid);
END;;

delimiter ;
