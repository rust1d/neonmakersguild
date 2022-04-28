DROP procedure IF EXISTS bloglinks_update;

delimiter ;;

CREATE PROCEDURE bloglinks_update(
  IN _bliid          int(11),
  IN _blog           int(11),
  IN _type           varchar(20),
  IN _url            varchar(200),
  IN _title          varchar(100),
  IN _description    varchar(200),
  IN _clicks         int(11)
)
BEGIN
  UPDATE bloglinks
     SET bli_blog        = IFNULL(_blog,         bli_blog),
         bli_type        = IFNULL(_type,         bli_type),
         bli_url         = IFNULL(_url,          bli_url),
         bli_title       = IFNULL(_title,        bli_title),
         bli_description = IFNULL(_description,  bli_description),
         bli_clicks      = IFNULL(_clicks,       bli_clicks),
         bli_dla         = CURRENT_TIMESTAMP
   WHERE bli_bliid = _bliid;

  CALL bloglinks_get_by_ids(_bliid);
END;;

delimiter ;
