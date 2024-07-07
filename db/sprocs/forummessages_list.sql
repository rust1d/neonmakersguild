DROP procedure IF EXISTS forummessages_list;

delimiter ;;

CREATE PROCEDURE forummessages_list(
  IN _ftid     INT(11),
  IN _deleted  TINYINT(1),
  IN _term     VARCHAR(25),
  IN _paging   VARCHAR(50)
)
BEGIN
  DECLARE _limit INT(11) DEFAULT get_page_data(_paging, 'limit');
  DECLARE _offset INT(11) DEFAULT get_page_data(_paging, 'offset');
  SET _term = clean_regexp(_term);

  SELECT SQL_CALC_FOUND_ROWS *
    FROM forummessages
         INNER JOIN forumthreads ON ft_ftid = fm_ftid
         INNER JOIN forums ON fo_foid = ft_foid
         INNER JOIN users ON us_usid = fm_usid
         INNER JOIN userprofile ON up_usid = us_usid
   WHERE (_ftid IS NULL OR fm_ftid = _ftid)
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
