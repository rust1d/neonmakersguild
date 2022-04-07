DROP procedure IF EXISTS blogentriescategories_replace;

delimiter ;;

CREATE PROCEDURE blogentriescategories_replace(
  IN _benid   INT,
  IN _bcaids  VARCHAR(100)
)
BEGIN
  DELETE
    FROM blogentriescategories
   WHERE bec_benid = _benid;

  CALL create_temp_table_id_list(_bcaids);

  INSERT INTO blogentriescategories (bec_benid, bec_bcaid)
    SELECT _benid, bca_bcaid
      FROM blogcategories
           INNER JOIN _id_list ON _il_id = bca_bcaid;

  SELECT *
    FROM blogentriescategories
   WHERE bec_benid = _benid;
END;;

delimiter ;
