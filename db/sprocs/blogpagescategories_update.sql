DROP procedure IF EXISTS blogpagescategories_update;

delimiter ;;

CREATE PROCEDURE blogpagescategories_update(
  IN _bpcid    int(11),
  IN _bcaid    int(11),
  IN _bpaid    int(11)
)
BEGIN
  UPDATE blogpagescategories
     SET bpc_bcaid = IFNULL(_bcaid,  bpc_bcaid),
         bpc_bpaid = IFNULL(_bpaid,  bpc_bpaid)
   WHERE bpc_bpcid = _bpcid;

  CALL blogpagescategories_get_by_ids(_bpcid);
END;;

delimiter ;
