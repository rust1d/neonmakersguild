DROP procedure IF EXISTS documents_get_by_ids;

delimiter ;;

CREATE PROCEDURE documents_get_by_ids(
  IN _ids text
)
BEGIN
  CALL create_temp_table_id_list(_ids);

  SELECT *
    FROM documents
         INNER JOIN _id_list ON _il_id = doc_docid;
END;;

delimiter ;
