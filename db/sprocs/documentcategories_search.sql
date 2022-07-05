DROP procedure IF EXISTS documentcategories_search;

delimiter ;;

CREATE PROCEDURE documentcategories_search(
  IN _dcid    int(11),
  IN _docid   int(11),
  IN _bcaid   int(11),
  IN _paging  varchar(50)
)
BEGIN
  DECLARE _limit INT(11) DEFAULT get_page_data(_paging, 'limit');
  DECLARE _offset INT(11) DEFAULT get_page_data(_paging, 'offset');

  SELECT SQL_CALC_FOUND_ROWS documentcategories.*, blogCategories.*
    FROM documentcategories
         INNER JOIN blogCategories ON bca_bcaid = dc_bcaid
   WHERE (_dcid IS NULL OR dc_dcid = _dcid)
     AND (_docid IS NULL OR dc_docid = _docid)
     AND (_bcaid IS NULL OR dc_bcaid = _bcaid)
   ORDER BY bca_category, bca_bcaid
   LIMIT _limit OFFSET _offset;

  CALL pagination(FOUND_ROWS(), _limit, _offset, null);
END;;

delimiter ;
