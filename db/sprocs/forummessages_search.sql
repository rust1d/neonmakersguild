DROP procedure IF EXISTS forummessages_search;

delimiter ;;

CREATE PROCEDURE forummessages_search(
  IN _fmid     INT(11),
  IN _foid     INT(11),
  IN _ftid     INT(11),
  IN _usid     INT(11),
  IN _deleted  TINYINT(1),
  IN _term     VARCHAR(25),
  IN _paging   VARCHAR(50)
)
BEGIN
  DECLARE _limit INT(11) DEFAULT get_page_data(_paging, 'limit');
  DECLARE _offset INT(11) DEFAULT get_page_data(_paging, 'offset');
  SET _term = clean_regexp(_term);

  SELECT SQL_CALC_FOUND_ROWS forummessages.*, fo_alias, ft_alias, us_user
    FROM forummessages
         INNER JOIN forumThreads ON ft_ftid = fm_ftid
         INNER JOIN forums ON fo_foid = fm_foid
         INNER JOIN users ON us_usid = fm_usid
   WHERE (_fmid IS NULL OR fm_fmid = _fmid)
     AND (_foid IS NULL OR fm_foid = _foid)
     AND (_ftid IS NULL OR fm_ftid = _ftid)
     AND (_usid IS NULL OR fm_usid = _usid)
     AND (_deleted IS NULL OR (_deleted=0 AND fm_deleted IS NULL) OR (_deleted=1 AND fm_deleted IS NOT NULL))
     AND (_term IS NULL OR
           us_user = _term OR
           fm_body REGEXP _term OR
           fm_history REGEXP _term
         )
   ORDER BY fm_added, fm_fmid
     LIMIT _limit OFFSET _offset;

  call pagination(FOUND_ROWS(), _limit, _offset, _term);
END;;

delimiter ;
