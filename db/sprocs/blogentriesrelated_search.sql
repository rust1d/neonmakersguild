DROP procedure IF EXISTS blogentriesrelated_search;

delimiter ;;

CREATE PROCEDURE blogentriesrelated_search(
  IN _breid       int(11),
  IN _benid       int(11),
  IN _relbenid    int(11)
)
BEGIN
  SELECT *
    FROM blogentriesrelated
   WHERE (_breid IS NULL OR bre_breid = _breid)
     AND (_benid IS NULL OR bre_benid = _benid)
     AND (_relbenid IS NULL OR bre_relbenid = _relbenid);
END;;

delimiter ;
