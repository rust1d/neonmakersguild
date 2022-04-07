DROP procedure IF EXISTS blogentriescategories_update;

delimiter ;;

CREATE PROCEDURE blogentriescategories_update(
  IN _becid    int(11),
  IN _benid    int(11),
  IN _bcaid    int(11)
)
BEGIN
  UPDATE blogentriescategories
     SET bec_benid = IFNULL(_benid,  bec_benid),
         bec_bcaid = IFNULL(_bcaid,  bec_bcaid)
   WHERE bec_becid = _becid;

  CALL blogentriescategories_get_by_ids(_becid);
END;;

delimiter ;
