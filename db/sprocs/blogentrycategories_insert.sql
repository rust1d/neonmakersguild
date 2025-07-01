DROP procedure IF EXISTS blogentrycategories_insert;

delimiter ;;

CREATE PROCEDURE blogentrycategories_insert(
  IN _benid    int(11),
  IN _bcaid    int(11)
)
BEGIN

  INSERT INTO blogentrycategories (
    bec_benid, bec_bcaid
  ) VALUES (
    _benid, _bcaid
  );

  CALL blogentrycategories_get_by_ids(LAST_INSERT_ID());
END;;

delimiter ;
