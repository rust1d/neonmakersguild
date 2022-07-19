DROP procedure IF EXISTS blogentries_search;

delimiter ;;

CREATE PROCEDURE blogentries_search(
  IN _benid       INT(11),
  IN _blog        INT(11),
  IN _usid        INT(11),
  IN _title       VARCHAR(100),
  IN _posted      DATETIME,
  IN _alias       VARCHAR(100),
  IN _released    TINYINT(1),
  IN _promoted    TINYINT(1),
  IN _bcaid       INT(11),
  IN _term        VARCHAR(25),
  IN _paging      VARCHAR(50)
)
BEGIN
  DECLARE _limit INT(11) DEFAULT get_page_data(_paging, 'limit');
  DECLARE _offset INT(11) DEFAULT get_page_data(_paging, 'offset');
  SET _term = clean_regexp(_term);

  SELECT SQL_CALC_FOUND_ROWS blogentries.*, us_user AS ben_blogname,
         (SELECT COUNT(*) FROM blogcomments WHERE bco_benid=ben_benid) AS ben_comment_cnt
    FROM blogentries
         INNER JOIN users ON us_usid = ben_blog
   WHERE (_benid IS NULL OR ben_benid = _benid)
     AND (_blog IS NULL OR ben_blog = _blog OR (_promoted = 1 AND _blog = 1 AND ben_promoted < CURRENT_TIMESTAMP))
     AND (_usid IS NULL OR ben_usid = _usid)
     AND (_title IS NULL OR ben_title = _title)
     AND (_posted IS NULL OR ben_posted = _posted)
     AND (_alias IS NULL OR ben_alias = _alias)
     AND (_released IS NULL OR (ben_released = _released AND ben_posted < CURRENT_TIMESTAMP))
     AND (_promoted IS NULL OR ben_blog = 1 OR ben_promoted < CURRENT_TIMESTAMP)
     AND (_bcaid IS NULL OR EXISTS (SELECT 1 FROM BlogEntriesCategories WHERE bec_bcaid=_bcaid AND bec_benid=ben_benid))
     AND (_term IS NULL OR
           us_user = _term OR
           ben_title REGEXP _term OR
           ben_alias REGEXP _term OR
           ben_body REGEXP _term OR
           ben_morebody REGEXP _term
         )
     ORDER BY
     CASE WHEN _released IS NULL THEN ben_added ELSE IFNULL(ben_promoted, ben_posted) END DESC, ben_benid DESC
     LIMIT _limit OFFSET _offset;

  call pagination(FOUND_ROWS(), _limit, _offset, _term);
END;;

delimiter ;
