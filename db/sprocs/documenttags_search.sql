DROP procedure IF EXISTS documenttags_search;

delimiter ;;

CREATE PROCEDURE documenttags_search(
  IN _dtid    int(11),
  IN _docid   int(11),
  IN _tagid   int(11),
  IN _paging  varchar(50)
)
BEGIN
  DECLARE _limit INT(11) DEFAULT get_page_data(_paging, 'limit');
  DECLARE _offset INT(11) DEFAULT get_page_data(_paging, 'offset');

  SELECT SQL_CALC_FOUND_ROWS documenttags.*, documents.*, tags.*
    FROM documenttags
         INNER JOIN documents ON doc_docid = dt_docid
         INNER JOIN tags ON tag_tagid = dt_tagid
   WHERE (_dtid IS NULL OR dt_dtid = _dtid)
     AND (_docid IS NULL OR dt_docid = _docid)
     AND (_tagid IS NULL OR dt_tagid = _tagid)
   ORDER BY tag_tag, tag_tagid
   LIMIT _limit OFFSET _offset;

  CALL pagination(FOUND_ROWS(), _limit, _offset, null);
END;;

delimiter ;
