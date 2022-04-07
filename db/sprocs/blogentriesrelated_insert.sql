DROP procedure IF EXISTS blogentriesrelated_insert;

delimiter ;;

CREATE PROCEDURE blogentriesrelated_insert(
  IN _benid       int(11),
  IN _relbenid    int(11)
)
BEGIN

  INSERT INTO blogentriesrelated (
    bre_benid, bre_relbenid
  ) VALUES (
    _benid, _relbenid
  );

  CALL blogentriesrelated_get_by_ids(LAST_INSERT_ID());
END;;

delimiter ;
