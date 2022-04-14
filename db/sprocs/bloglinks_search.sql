DROP procedure IF EXISTS bloglinks_search;

delimiter ;;

CREATE PROCEDURE bloglinks_search(
  IN _bliid    int(11),
  IN _blog     int(11)
)
BEGIN
  SELECT *
    FROM bloglinks
   WHERE (_bliid IS NULL OR bli_bliid = _bliid)
     AND (_blog IS NULL OR bli_blog = _blog);
END;;

delimiter ;
