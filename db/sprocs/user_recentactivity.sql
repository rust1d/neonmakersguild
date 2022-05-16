DROP procedure IF EXISTS user_recentActivity;

delimiter ;;

CREATE PROCEDURE user_recentActivity(
  IN _usid     INT(11),
  IN _term     VARCHAR(20),
  IN _paging   VARCHAR(50)
)
BEGIN
  DECLARE _limit INT(11) DEFAULT get_page_data(_paging, 'limit');
  DECLARE _offset INT(11) DEFAULT get_page_data(_paging, 'offset');

  SELECT SQL_CALC_FOUND_ROWS *
    FROM (
           SELECT 'post' AS act_source, LOWER(CONCAT(us_user, '/', ben_alias)) AS act_seolink, ben_benid AS act_pkid, ben_benid AS act_fkid, ben_title AS act_title, ben_body AS act_words, ben_dla AS act_dla
             FROM blogentries
                  INNER JOIN users ON us_usid = ben_blog
            WHERE ben_usid = _usid
              AND ben_released = 1
              AND CASE WHEN _term IS NULL
                    THEN ben_dla > DATE_ADD(CURRENT_TIMESTAMP, INTERVAL -60 DAY)
                    ELSE ben_title REGEXP CONVERT(_term USING utf8) OR
                    ben_alias REGEXP CONVERT(_term USING utf8) OR
                    ben_body REGEXP CONVERT(_term USING utf8) OR
                    ben_morebody REGEXP CONVERT(_term USING utf8)
                  END

            UNION

           SELECT 'comment' AS act_source, LOWER(CONCAT(us_user, '/', ben_alias)) AS act_seolink, bco_bcoid AS act_pkid, bco_benid AS act_fkid, ben_title AS act_title, bco_comment AS act_words, bco_dla AS act_dla
             FROM blogcomments
                 INNER JOIN blogentries ON ben_benid = bco_benid
                 INNER JOIN users ON us_usid = ben_blog
            WHERE bco_usid = _usid
              AND CASE WHEN _term IS NULL
                    THEN bco_dla > DATE_ADD(CURRENT_TIMESTAMP, INTERVAL -60 DAY)
                    ELSE bco_comment REGEXP CONVERT(_term USING utf8)
                  END

           UNION

           SELECT 'thread' AS act_source, CONCAT(fo_alias, '/', ft_ftid, '/', ft_alias) AS act_seolink, ft_ftid AS act_pkid, ft_foid AS act_fkid, fo_name AS act_title, ft_subject AS act_words, ft_dla AS act_dla
             FROM forumthreads
                 INNER JOIN forums ON fo_foid = ft_foid
           WHERE ft_usid = _usid
             AND ft_deleted IS NULL
             AND CASE WHEN _term IS NULL
                    THEN ft_dla > DATE_ADD(CURRENT_TIMESTAMP, INTERVAL -60 DAY)
                    ELSE ft_subject REGEXP CONVERT(_term USING utf8)
                  END

           UNION

           SELECT 'message' AS act_source, CONCAT(fo_alias, '/', ft_ftid, '/', ft_alias) AS act_seolink, fm_fmid AS act_pkid, fm_ftid AS act_fkid, ft_subject AS act_title, fm_body AS act_words, fm_dla AS act_dla
             FROM forummessages
                 INNER JOIN forumthreads ON ft_ftid = fm_ftid
                 INNER JOIN forums ON fo_foid = ft_foid
           WHERE fm_usid = _usid
             AND fm_deleted IS NULL
             AND fm_dla > DATE_ADD(CURRENT_TIMESTAMP, INTERVAL -60 DAY)
             AND CASE WHEN _term IS NULL
                    THEN ft_dla > DATE_ADD(CURRENT_TIMESTAMP, INTERVAL -60 DAY)
                    ELSE fm_body REGEXP CONVERT(_term USING utf8)
                  END
         ) AS tmp
  ORDER BY act_dla DESC
  LIMIT _limit OFFSET _offset;

  call pagination(FOUND_ROWS(), _limit, _offset, _term);
END;;

delimiter ;
