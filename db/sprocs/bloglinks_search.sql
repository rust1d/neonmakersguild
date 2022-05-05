DROP procedure IF EXISTS bloglinks_search;

delimiter ;;

CREATE PROCEDURE bloglinks_search(
  IN _bliid    INT(11),
  IN _blog     INT(11),
  IN _type     VARCHAR(20),
  IN _term     VARCHAR(20),
  IN _paging   VARCHAR(50)
)
BEGIN
  DECLARE _limit INT(11) DEFAULT get_page_data(_paging, 'limit');
  DECLARE _offset INT(11) DEFAULT get_page_data(_paging, 'offset');

  SELECT SQL_CALC_FOUND_ROWS *
    FROM bloglinks
   WHERE (_bliid IS NULL OR bli_bliid = _bliid)
     AND (_blog IS NULL OR bli_blog = _blog)
     AND (_type IS NULL OR bli_type = CONVERT(_type USING utf8))
     AND (_term IS NULL OR
           bli_url = CONVERT(_term USING utf8) OR
           bli_title REGEXP CONVERT(_term USING utf8) OR
           bli_description REGEXP CONVERT(_term USING utf8)
         )
     ORDER BY bli_type, bli_title, bli_bliid
     LIMIT _limit OFFSET _offset;

  SELECT FOUND_ROWS() AS total, IF(FOUND_ROWS() < _limit, FOUND_ROWS(), _limit) AS page_size, CEIL(FOUND_ROWS()/_limit) AS pages, 1+ROUND(_offset/_limit) AS page;
END;;

delimiter ;
