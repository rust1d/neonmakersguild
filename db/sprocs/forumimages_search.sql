DROP procedure IF EXISTS forumimages_search;

delimiter ;;

CREATE PROCEDURE forumimages_search(
  IN _fiid     INT(11),
  IN _foid     INT(11),
  IN _ftid     INT(11),
  IN _fmid     INT(11),
  IN _usid     INT(11),
  IN _paging   VARCHAR(50)
)
BEGIN
  DECLARE _limit INT(11) DEFAULT get_page_data(_paging, 'limit');
  DECLARE _offset INT(11) DEFAULT get_page_data(_paging, 'offset');

  SELECT SQL_CALC_FOUND_ROWS *
    FROM forumimages
   WHERE (_fiid IS NULL OR fi_fiid = _fiid)
     AND (_foid IS NULL OR fi_foid = _foid)
     AND (_ftid IS NULL OR fi_ftid = _ftid)
     AND (_fmid IS NULL OR fi_fmid = _fmid)
     AND (_usid IS NULL OR fi_usid = _usid)
   ORDER BY fi_fiid
   LIMIT _limit OFFSET _offset;

  call pagination(FOUND_ROWS(), _limit, _offset, null);
END;;

delimiter ;
