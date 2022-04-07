DROP procedure IF EXISTS blogentriesrelated_replace;

delimiter ;;

CREATE PROCEDURE blogentriesrelated_replace(
  IN _benid   INT,
  IN _relids  VARCHAR(100)
)
BEGIN
  DELETE
    FROM blogentriesrelated
   WHERE ber_benid = _benid;

  CALL create_temp_table_id_list(_relids);

  INSERT INTO blogentriesrelated (bre_benid, bre_relbenid)
    SELECT _benid, ben_benid
      FROM blogentries
           INNER JOIN _id_list ON _il_id = ben_benid;

  SELECT *
    FROM blogentriesrelated
   WHERE bre_benid = _benid;
END;;

delimiter ;
