DROP procedure IF EXISTS blogentrycategories_search;

delimiter ;;

CREATE PROCEDURE blogentrycategories_search(
  IN _becid    int(11),
  IN _benid    int(11),
  IN _bcaid    int(11),
  IN _paging   varchar(50)
)
BEGIN
  DECLARE _limit INT(11) DEFAULT get_page_data(_paging, 'limit');
  DECLARE _offset INT(11) DEFAULT get_page_data(_paging, 'offset');

  SELECT SQL_CALC_FOUND_ROWS blogentrycategories.*, blogCategories.*, users.*
    FROM blogentrycategories
         INNER JOIN blogCategories ON bca_bcaid = bec_bcaid
         INNER JOIN users ON us_usid = bca_blog
   WHERE (_becid IS NULL OR bec_becid = _becid)
     AND (_benid IS NULL OR bec_benid = _benid)
     AND (_bcaid IS NULL OR bec_bcaid = _bcaid)
   ORDER BY bca_category
   LIMIT _limit OFFSET _offset;

  CALL pagination(FOUND_ROWS(), _limit, _offset, null);
END;;

delimiter ;
