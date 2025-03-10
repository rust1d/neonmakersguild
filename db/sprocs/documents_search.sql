DROP procedure IF EXISTS documents_search;

delimiter ;;

CREATE PROCEDURE documents_search(
  IN _docid    int(11),
  IN _blog     int(11),
  IN _bcaid    int(11),
  IN _tag      VARCHAR(25),
  IN _term     VARCHAR(25),
  IN _sort     VARCHAR(25),
  IN _paging   VARCHAR(50)
)
BEGIN
  DECLARE _limit INT(11) DEFAULT get_page_data(_paging, 'limit');
  DECLARE _offset INT(11) DEFAULT get_page_data(_paging, 'offset');
  SET _sort = IFNULL(_sort, 'filename');
  SET _term = clean_regexp(_term);

  SELECT SQL_CALC_FOUND_ROWS *
    FROM documents
   WHERE (_docid IS NULL OR doc_docid = _docid)
     AND (_blog IS NULL OR doc_blog = _blog)
     AND (_term IS NULL OR
           doc_type REGEXP _term OR
           doc_filename REGEXP _term OR
           doc_description REGEXP _term
         )
     AND (_bcaid IS NULL OR
           doc_docid IN (
             SELECT dc_docid
               FROM documentcategories
              WHERE dc_bcaid=_bcaid
           )
         )
     AND (_tag IS NULL OR
           doc_docid IN (
             SELECT dt_docid
               FROM tags
                    INNER JOIN documentTags ON tag_tagid=dt_tagid AND tag_tag REGEXP clean_regexp(_tag)
              WHERE dt_docid=doc_docid
           )
         )
   ORDER BY
     CASE WHEN _sort='filename' THEN doc_filename
          WHEN _sort='added' THEN DATEDIFF(NOW(), doc_added)
          WHEN _sort='views' THEN now()-doc_views
      END, doc_filename, doc_docid
   LIMIT _limit OFFSET _offset;

  call pagination(FOUND_ROWS(), _limit, _offset, _term);
END;;

delimiter ;
