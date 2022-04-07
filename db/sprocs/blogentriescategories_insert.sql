DROP procedure IF EXISTS blogentriescategories_insert;

delimiter ;;

CREATE PROCEDURE blogentriescategories_insert(
  IN _benid    int(11),
  IN _bcaid    int(11)
)
BEGIN

  INSERT INTO blogentriescategories (
    bec_benid, bec_bcaid
  ) VALUES (
    _benid, _bcaid
  );

  CALL blogentriescategories_get_by_ids(LAST_INSERT_ID());
END;;

delimiter ;
