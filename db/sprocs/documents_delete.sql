DROP procedure IF EXISTS documents_delete;

delimiter ;;

CREATE PROCEDURE documents_delete(
  IN _docid integer
)
BEGIN
  DELETE
    FROM documents
   WHERE doc_docid = _docid;

  SELECT ROW_COUNT() AS delete_count;
END;;

delimiter ;
