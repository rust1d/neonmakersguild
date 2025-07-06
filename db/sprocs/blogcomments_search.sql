DROP procedure IF EXISTS blogcomments_search;

delimiter ;;

CREATE PROCEDURE blogcomments_search(
  IN _bcoid    int(11),
  IN _blog     int(11),
  IN _benid    int(11),
  IN _beiid    int(11),
  IN _usid     int(11),
  IN _paging   VARCHAR(50)
)
BEGIN
  DECLARE _limit INT(11) DEFAULT get_page_data(_paging, 'limit');
  DECLARE _offset INT(11) DEFAULT get_page_data(_paging, 'offset');

  SELECT SQL_CALC_FOUND_ROWS blogcomments.*,
         (SELECT COUNT(*) FROM commentimages WHERE ci_bcoid=bco_bcoid) AS bco_image_cnt
    FROM blogcomments
   WHERE (_bcoid IS NULL OR bco_bcoid = _bcoid)
     AND (_blog IS NULL OR bco_blog = _blog)
     AND (_benid IS NULL OR bco_benid = _benid)
     AND (_beiid IS NULL OR bco_beiid = _beiid)
     AND (_usid IS NULL OR bco_usid = _usid)
   ORDER BY bco_added
   LIMIT _limit OFFSET _offset;

  call pagination(FOUND_ROWS(), _limit, _offset, null);
END;;

delimiter ;
