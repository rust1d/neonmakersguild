DROP procedure IF EXISTS pagination;

delimiter ;;

CREATE PROCEDURE pagination(
  IN _found  INTEGER,
  IN _limit  INTEGER,
  IN _offset INTEGER,
  IN _term   VARCHAR(25)
)
BEGIN
  IF (_found=0) THEN
    SELECT 0 AS total, 0 AS page_size, 0 AS pages, 0 AS page, 0 AS first, 0 AS last, 1 AS one_page, 0 AS next, 0 AS prev, 0 AS start, 0 AS `end`, 0 AS `count`, _term AS term;
  ELSE
    SELECT *, IF(last, total, start + page_size - 1) AS `end`, IF(last && !first, total - start, page_size) AS `count`, _term AS term
    FROM (
           SELECT *, page=1 AS first, page=pages AS last, pages=1 AS one_page, page+1 AS next, page-1 AS prev, 1 + (page-1) * page_size AS start
             FROM (
                    SELECT _found AS total, IF(_found < _limit, _found, _limit) AS page_size, CEIL(_found/_limit) AS pages, 1+ROUND(_offset/_limit) AS page
                  ) AS tmp1
         ) AS tmp2;
  END IF;
END;;

delimiter ;
