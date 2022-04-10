DROP procedure IF EXISTS blogpagescategories_insert;

delimiter ;;

CREATE PROCEDURE blogpagescategories_insert(
  IN _bcaid    int(11),
  IN _bpaid    int(11)
)
BEGIN

  INSERT INTO blogpagescategories (
    bpc_bcaid, bpc_bpaid
  ) VALUES (
    _bcaid, _bpaid
  );

  CALL blogpagescategories_get_by_ids(LAST_INSERT_ID());
END;;

delimiter ;
