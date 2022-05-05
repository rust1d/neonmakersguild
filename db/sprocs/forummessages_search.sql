DROP procedure IF EXISTS forummessages_search;

delimiter ;;

CREATE PROCEDURE forummessages_search(
  IN _fmid   int(11),
  IN _foid   int(11),
  IN _ftid   int(11),
  IN _usid   int(11),
  IN _term   VARCHAR(20),
  IN _paging VARCHAR(50)
)
BEGIN
  DECLARE _limit INT(11) DEFAULT get_page_data(_paging, 'limit');
  DECLARE _offset INT(11) DEFAULT get_page_data(_paging, 'offset');

  SELECT SQL_CALC_FOUND_ROWS forummessages.*, fo_alias, ft_alias, us_user
    FROM forummessages
         INNER JOIN forumThreads ON ft_ftid = fm_ftid
         INNER JOIN forums ON fo_foid = fm_foid
         INNER JOIN users ON us_usid = fm_usid
   WHERE fm_deleted IS NULL
     AND (_fmid IS NULL OR fm_fmid = _fmid)
     AND (_foid IS NULL OR fm_foid = _foid)
     AND (_ftid IS NULL OR fm_ftid = _ftid)
     AND (_usid IS NULL OR fm_usid = _usid)
     AND (_term IS NULL OR
           us_user = CONVERT(_term USING utf8) OR
           fm_body REGEXP CONVERT(_term USING utf8) OR
           fm_history REGEXP CONVERT(_term USING utf8)
         )
   ORDER BY fm_dla DESC, fm_fmid DESC
     LIMIT _limit OFFSET _offset;

  SELECT FOUND_ROWS() AS total, IF(FOUND_ROWS() < _limit, FOUND_ROWS(), _limit) AS page_size, CEIL(FOUND_ROWS()/_limit) AS pages, 1+ROUND(_offset/_limit) AS page;
END;;

delimiter ;
