DROP FUNCTION IF EXISTS get_page_data;

delimiter ;;

CREATE FUNCTION get_page_data(
  _paging VARCHAR(100),
  _key  VARCHAR(10)
) RETURNS INT
BEGIN
  SET _paging = IF(_paging='', '{}', _paging);

  RETURN IF(_key='limit',
    IFNULL(JSON_EXTRACT(_paging, CONCAT('$.limit')), 10000),
    IFNULL(JSON_EXTRACT(_paging, CONCAT('$.offset')), 0)
  );
END
;;
