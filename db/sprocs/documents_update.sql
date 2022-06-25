DROP procedure IF EXISTS documents_update;

delimiter ;;

CREATE PROCEDURE documents_update(
  IN _docid          int(11),
  IN _blog           int(11),
  IN _type           varchar(10),
  IN `_filename`     varchar(100),
  IN _description    varchar(500),
  IN _size           int(11),
  IN _clicks         int(11)
)
BEGIN
  UPDATE documents
     SET doc_blog        = IFNULL(_blog,         doc_blog),
         doc_type        = IFNULL(_type,         doc_type),
         doc_filename    = IFNULL(`_filename`,   doc_filename),
         doc_description = IFNULL(_description,  doc_description),
         doc_size        = IFNULL(_size,         doc_size),
         doc_clicks      = IFNULL(_clicks,       doc_clicks),
         doc_dla         = CURRENT_TIMESTAMP
   WHERE doc_docid = _docid;

  CALL documents_get_by_ids(_docid);
END;;

delimiter ;
