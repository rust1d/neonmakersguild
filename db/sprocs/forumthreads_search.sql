DROP procedure IF EXISTS forumthreads_search;

delimiter ;;

CREATE PROCEDURE forumthreads_search(
  IN _ftid    INT(11),
  IN _foid    INT(11),
  IN _usid    INT(11),
  IN _deleted TINYINT(1),
  IN _term    VARCHAR(25),
  IN _paging  VARCHAR(50)
)
BEGIN
  DECLARE _limit INT(11) DEFAULT get_page_data(_paging, 'limit');
  DECLARE _offset INT(11) DEFAULT get_page_data(_paging, 'offset');
  SET _term = clean_regexp(_term);

  SELECT SQL_CALC_FOUND_ROWS forumthreads.*, fo_alias, us_user
    FROM forumthreads
         INNER JOIN forums ON fo_foid = ft_foid
         INNER JOIN users ON us_usid = ft_usid
   WHERE (_ftid IS NULL OR ft_ftid = _ftid)
     AND (_foid IS NULL OR ft_foid = _foid)
     AND (_usid IS NULL OR ft_usid = _usid)
     AND (_deleted IS NULL OR (_deleted=0 AND ft_deleted IS NULL) OR (_deleted=1 AND ft_deleted IS NOT NULL))
     AND (_term IS NULL OR
           us_user = _term OR
           ft_subject REGEXP _term OR
           ft_alias REGEXP _term
         )
   ORDER BY ft_dla DESC, ft_ftid DESC
     LIMIT _limit OFFSET _offset;

  call pagination(FOUND_ROWS(), _limit, _offset, _term);
END;;

delimiter ;
