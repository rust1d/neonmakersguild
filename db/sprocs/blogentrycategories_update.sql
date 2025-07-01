DROP procedure IF EXISTS blogentrycategories_update;

delimiter ;;

CREATE PROCEDURE blogentrycategories_update(
  IN _becid    int(11),
  IN _benid    int(11),
  IN _bcaid    int(11)
)
BEGIN
  UPDATE blogentrycategories
     SET bec_benid = IFNULL(_benid,  bec_benid),
         bec_bcaid = IFNULL(_bcaid,  bec_bcaid)
   WHERE bec_becid = _becid;

  CALL blogentrycategories_get_by_ids(_becid);
END;;

delimiter ;
