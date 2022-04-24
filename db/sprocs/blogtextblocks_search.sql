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
     AND (_label IS NULL OR btb_label = _label OR (RIGHT(_label,1)='%' AND btb_label like _label))
     ORDER BY CASE WHEN _label IS NULL THEN btb_btbid ELSE btb_label END;
END;;

delimiter ;
