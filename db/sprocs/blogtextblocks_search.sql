DROP procedure IF EXISTS blogtextblocks_search;

delimiter ;;

CREATE PROCEDURE blogtextblocks_search(
  IN _btbid    int(11),
  IN _blog     int(11),
  IN _label    varchar(100)
)
BEGIN
  SELECT *
    FROM blogtextblocks
   WHERE (_btbid IS NULL OR btb_btbid = _btbid)
     AND (_blog IS NULL OR btb_blog = _blog)
     AND (_label IS NULL OR btb_label = _label);
END;;

delimiter ;
