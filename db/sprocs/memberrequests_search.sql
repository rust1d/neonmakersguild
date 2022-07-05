DROP procedure IF EXISTS memberrequests_search;

delimiter ;;

CREATE PROCEDURE memberrequests_search(
  IN _mrid   int(11),
  IN _paging  varchar(50)
)
BEGIN
  DECLARE _limit INT(11) DEFAULT get_page_data(_paging, 'limit');
  DECLARE _offset INT(11) DEFAULT get_page_data(_paging, 'offset');

  SELECT SQL_CALC_FOUND_ROWS *
    FROM memberrequests
   WHERE mr_deleted IS NULL
     AND (_mrid IS NULL OR mr_mrid = _mrid)
   ORDER BY mr_mrid
   LIMIT _limit OFFSET _offset;

  CALL pagination(FOUND_ROWS(), _limit, _offset, null);
END;;

delimiter ;
