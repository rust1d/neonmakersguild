DROP procedure IF EXISTS commentimages_search;

delimiter ;;

CREATE PROCEDURE commentimages_search(
  IN _ciid          int(11),
  IN _bcoid         int(11),
  IN _benid         int(11),
  IN _beiid         int(11),
  IN _usid          int(11)
)
BEGIN
  SELECT *
    FROM commentimages
   WHERE (_ciid IS NULL OR ci_ciid = _ciid)
     AND (_bcoid IS NULL OR ci_bcoid = _bcoid)
     AND (_benid IS NULL OR ci_benid = _benid)
     AND (_beiid IS NULL OR ci_beiid = _beiid)
     AND (_usid IS NULL OR ci_usid = _usid);
END;;

delimiter ;
