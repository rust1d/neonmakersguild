DROP procedure IF EXISTS blogpagescategories_replace;

delimiter ;;

CREATE PROCEDURE blogpagescategories_replace(
  IN _bpaid   INT,
  IN _bcaids  VARCHAR(100)
)
BEGIN
  DELETE
    FROM blogpagescategories
   WHERE bpc_bpaid = _bpaid;

  CALL create_temp_table_id_list(_bcaids);

  INSERT INTO blogpagescategories (bpc_bpaid, bpc_bcaid)
    SELECT _bpaid, bca_bcaid
      FROM blogcategories
           INNER JOIN _id_list ON _il_id = bca_bcaid;

  SELECT *
    FROM blogpagescategories
   WHERE bpc_bpaid = _bpaid;
END;;

delimiter ;
