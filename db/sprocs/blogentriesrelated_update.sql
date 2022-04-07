DROP procedure IF EXISTS blogentriesrelated_update;

delimiter ;;

CREATE PROCEDURE blogentriesrelated_update(
  IN _breid       int(11),
  IN _benid       int(11),
  IN _relbenid    int(11)
)
BEGIN
  UPDATE blogentriesrelated
     SET bre_benid    = IFNULL(_benid,     bre_benid),
         bre_relbenid = IFNULL(_relbenid,  bre_relbenid)
   WHERE bre_breid = _breid;

  CALL blogentriesrelated_get_by_ids(_breid);
END;;

delimiter ;
