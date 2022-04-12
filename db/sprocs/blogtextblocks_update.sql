DROP procedure IF EXISTS blogtextblocks_update;

delimiter ;;

CREATE PROCEDURE blogtextblocks_update(
  IN _btbid    int(11),
  IN _label    varchar(100),
  IN _body     longtext,
  IN _blog     int(11)
)
BEGIN
  UPDATE blogtextblocks
     SET btb_label = IFNULL(_label,  btb_label),
         btb_body  = IFNULL(_body,   btb_body),
         btb_blog  = IFNULL(_blog,   btb_blog)
   WHERE btb_btbid = _btbid;

  CALL blogtextblocks_get_by_ids(_btbid);
END;;

delimiter ;
