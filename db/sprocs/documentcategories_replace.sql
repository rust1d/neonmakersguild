DROP procedure IF EXISTS documentCategories_replace;

delimiter ;;

CREATE PROCEDURE documentCategories_replace(
  IN _docid   INT,
  IN _bcaids  VARCHAR(100)
)
BEGIN
  DELETE
    FROM documentCategories
   WHERE dc_docid = _docid;

  CALL create_temp_table_id_list(_bcaids);

  INSERT INTO documentCategories (dc_docid, dc_bcaid)
    SELECT _docid, bca_bcaid
      FROM blogcategories
           INNER JOIN _id_list ON _il_id = bca_bcaid;

  SELECT *
    FROM documentCategories
   WHERE dc_docid = _docid;
END;;

delimiter ;
