DROP procedure IF EXISTS blogcomments_search;

delimiter ;;

CREATE PROCEDURE blogcomments_search(
  IN _bcoid    int(11),
  IN _blog     int(11),
  IN _benid    int(11),
  IN _usid     int(11)
)
BEGIN
  SELECT *
    FROM blogcomments
   WHERE (_bcoid IS NULL OR bco_bcoid = _bcoid)
     AND (_blog IS NULL OR bco_blog = _blog)
     AND (_benid IS NULL OR bco_benid = _benid)
     AND (_usid IS NULL OR bco_usid = _usid)
     ORDER BY bco_added DESC;
END;;

delimiter ;
