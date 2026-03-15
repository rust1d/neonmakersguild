DROP procedure IF EXISTS usernotifications_search;

delimiter ;;

CREATE PROCEDURE usernotifications_search(
  IN _unid         INT,
  IN _usid         INT,
  IN _type         VARCHAR(50),
  IN _read         TINYINT,
  IN _paging       VARCHAR(50)
)
BEGIN
  DECLARE _limit INT(11) DEFAULT get_page_data(_paging, 'limit');
  DECLARE _offset INT(11) DEFAULT get_page_data(_paging, 'offset');

  SELECT SQL_CALC_FOUND_ROWS usernotifications.*
    FROM usernotifications
   WHERE (_unid IS NULL OR un_unid = _unid)
     AND (_usid IS NULL OR un_usid = _usid)
     AND (_type IS NULL OR un_type = _type)
     AND (_read IS NULL OR un_read = _read)
   ORDER BY un_unid DESC
   LIMIT _limit OFFSET _offset;

   call pagination(FOUND_ROWS(), _limit, _offset, null);
END;;

delimiter ;
