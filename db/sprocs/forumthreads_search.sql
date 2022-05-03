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

  SELECT SQL_CALC_FOUND_ROWS forumthreads.*, fo_alias
    FROM forumthreads
         INNER JOIN forums ON fo_foid = ft_foid
         INNER JOIN users ON us_usid = ft_usid
   WHERE ft_deleted IS NULL
     AND (_ftid IS NULL OR ft_ftid = _ftid)
     AND (_foid IS NULL OR ft_foid = _foid)
     AND (_usid IS NULL OR ft_usid = _usid)
     AND (_term IS NULL OR CONCAT(ft_subject, ' ', IFNULL(ft_alias, ''), ' ', IFNULL(us_user, '')) REGEXP CONVERT(_term USING utf8))
   ORDER BY ft_dla, ft_ftid DESC
     LIMIT _limit OFFSET _offset;

  SELECT FOUND_ROWS() AS total, IF(FOUND_ROWS() < _limit, FOUND_ROWS(), _limit) AS page_size, CEIL(FOUND_ROWS()/_limit) AS pages, 1+ROUND(_offset/_limit) AS page;
END;;

delimiter ;
