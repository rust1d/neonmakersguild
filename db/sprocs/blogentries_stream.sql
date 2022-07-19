DROP procedure IF EXISTS blogentries_stream;

delimiter ;;

CREATE PROCEDURE blogentries_stream(
  IN _days        INT(11),
  IN _count       INT(11),
  IN _term        VARCHAR(25),
  IN _paging      VARCHAR(50)
)
BEGIN
  DECLARE _limit INT(11) DEFAULT get_page_data(_paging, 'limit');
  DECLARE _offset INT(11) DEFAULT get_page_data(_paging, 'offset');
  SET _term = clean_regexp(_term);

  SELECT SQL_CALC_FOUND_ROWS blogstream.*,
         (SELECT COUNT(*) FROM blogcomments WHERE bco_benid=ben_benid) AS ben_comment_cnt
     FROM (SELECT @lastUser:=0, @lastSeq:=0) AS vars,
          (
            SELECT blogentries.*, us_user AS ben_blogname,
                   @lastSeq:=if(@lastUser=ben_blog, @lastSeq+1, 1) AS seq, @lastUser:=ben_blog AS last_user
              FROM blogentries
                   INNER JOIN users ON us_usid = ben_usid
             WHERE ben_blog > 1 -- EXCLUDE SITE BLOG
               AND ben_posted < CURRENT_TIMESTAMP AND ben_posted >= DATE_ADD(CURRENT_TIMESTAMP, INTERVAL -IFNULL(_days, 30) DAY)
               AND (_term IS NULL OR
                     us_user = _term OR
                     ben_title REGEXP _term OR
                     ben_alias REGEXP _term OR
                     ben_body REGEXP _term OR
                     ben_morebody REGEXP _term
                   )
             ORDER BY ben_blog, ben_posted DESC
          ) AS blogstream
          WHERE seq <= IFNULL(_count, 3)
   ORDER BY IFNULL(ben_promoted, ben_posted) DESC, ben_benid DESC
     LIMIT _limit OFFSET _offset;

  call pagination(FOUND_ROWS(), _limit, _offset, _term);
END;;

delimiter ;
