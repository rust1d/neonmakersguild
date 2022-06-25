DROP procedure IF EXISTS blogtextblocks_search;

delimiter ;;

CREATE PROCEDURE blogtextblocks_search(
  IN _btbid    int(11),
  IN _blog     int(11),
  IN _label    varchar(100),
  IN _term     VARCHAR(25),
  IN _paging   VARCHAR(50)
)
BEGIN
  DECLARE _limit INT(11) DEFAULT get_page_data(_paging, 'limit');
  DECLARE _offset INT(11) DEFAULT get_page_data(_paging, 'offset');

  SELECT SQL_CALC_FOUND_ROWS *
    FROM blogtextblocks
   WHERE (_btbid IS NULL OR btb_btbid = _btbid)
     AND (_blog IS NULL OR btb_blog = _blog)
     AND (_label IS NULL OR btb_label = _label OR (RIGHT(_label,1)='%' AND btb_label like _label))
   ORDER BY CASE WHEN _label IS NULL THEN btb_btbid ELSE btb_label END
   LIMIT _limit OFFSET _offset;

  call pagination(FOUND_ROWS(), _limit, _offset, _term);
END;;

delimiter ;
