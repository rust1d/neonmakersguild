DROP procedure IF EXISTS documents_search;

delimiter ;;

CREATE PROCEDURE documents_search(
  IN _docid    int(11),
  IN _blog     int(11),
  IN _tag      VARCHAR(25),
  IN _term     VARCHAR(25),
  IN _paging   VARCHAR(50)
)
BEGIN
  DECLARE _limit INT(11) DEFAULT get_page_data(_paging, 'limit');
  DECLARE _offset INT(11) DEFAULT get_page_data(_paging, 'offset');

  SELECT SQL_CALC_FOUND_ROWS *
    FROM documents
   WHERE (_docid IS NULL OR doc_docid = _docid)
     AND (_blog IS NULL OR doc_blog = _blog)
     AND (_term IS NULL OR
           doc_type REGEXP CONVERT(_term USING utf8) OR
           doc_filename REGEXP CONVERT(_term USING utf8) OR
           doc_description REGEXP CONVERT(_term USING utf8)
         )
     AND (_tag IS NULL OR
           doc_docid IN (
             SELECT dt_docid
               FROM tags
                    INNER JOIN documentTags ON tag_tagid=dt_tagid AND tag_tag REGEXP CONVERT(_tag USING latin1)
              WHERE dt_docid=doc_docid
           )
         )
   ORDER BY doc_docid
   LIMIT _limit OFFSET _offset;

  call pagination(FOUND_ROWS(), _limit, _offset, _term);
END;;

delimiter ;
