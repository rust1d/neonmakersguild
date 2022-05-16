DROP procedure IF EXISTS forumthreads_search;

delimiter ;;

CREATE PROCEDURE forumthreads_search(
  IN _ftid   INT(11),
  IN _foid   INT(11),
  IN _usid   INT(11),
  IN _term   VARCHAR(20),
  IN _paging VARCHAR(50)
)
BEGIN
  DECLARE _limit INT(11) DEFAULT get_page_data(_paging, 'limit');
  DECLARE _offset INT(11) DEFAULT get_page_data(_paging, 'offset');

  SELECT SQL_CALC_FOUND_ROWS forumthreads.*, fo_alias, us_user
    FROM forumthreads
         INNER JOIN forums ON fo_foid = ft_foid
         INNER JOIN users ON us_usid = ft_usid
   WHERE ft_deleted IS NULL
     AND (_ftid IS NULL OR ft_ftid = _ftid)
     AND (_foid IS NULL OR ft_foid = _foid)
     AND (_usid IS NULL OR ft_usid = _usid)
     AND (_term IS NULL OR
           us_user = CONVERT(_term USING utf8) OR
           ft_subject REGEXP CONVERT(_term USING utf8) OR
           ft_alias REGEXP CONVERT(_term USING utf8)
         )
   ORDER BY ft_dla DESC, ft_ftid DESC
     LIMIT _limit OFFSET _offset;

  call pagination(FOUND_ROWS(), _limit, _offset, _term);
END;;

delimiter ;
