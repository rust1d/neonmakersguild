DROP procedure IF EXISTS tags_search;

delimiter ;;

CREATE PROCEDURE tags_search(
  IN _tagid    int(11),
  IN _blog     int(11),
  IN _tag      varchar(25),
  IN _paging   varchar(50)
)
BEGIN
  DECLARE _limit INT(11) DEFAULT get_page_data(_paging, 'limit');
  DECLARE _offset INT(11) DEFAULT get_page_data(_paging, 'offset');

  SELECT SQL_CALC_FOUND_ROWS tags.*, IFNULL(doc_count, 0) AS doc_count
    FROM tags
         LEFT OUTER JOIN (
           SELECT dt_tagid, COUNT(*) AS doc_count
             FROM documentTags
            GROUP BY dt_tagid
         ) AS dtCnt ON dt_tagid = tag_tagid
   WHERE (_tagid IS NULL OR tag_tagid = _tagid)
     AND (_blog IS NULL OR tag_blog = _blog)
     AND (_tag IS NULL OR tag_tag = _tag OR (RIGHT(_tag, 1)='%' AND tag_tag LIKE _tag))
   ORDER BY tag_tag
   LIMIT _limit OFFSET _offset;

  call pagination(FOUND_ROWS(), _limit, _offset, null);
END;;

delimiter ;
