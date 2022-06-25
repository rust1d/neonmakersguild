DROP procedure IF EXISTS documents_insert;

delimiter ;;

CREATE PROCEDURE documents_insert(
  IN _blog           int(11),
  IN _type           varchar(10),
  IN `_filename`     varchar(100),
  IN _description    varchar(500),
  IN _size           int(11),
  IN _clicks         int(11)
)
BEGIN
  SET _clicks = IFNULL(_clicks, 0);

  INSERT INTO documents (
    doc_blog, doc_type, doc_filename, doc_description, doc_size, doc_clicks, doc_added, doc_dla
  ) VALUES (
    _blog, _type, `_filename`, _description, _size, _clicks, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
  );

  CALL documents_get_by_ids(LAST_INSERT_ID());
END;;

delimiter ;
