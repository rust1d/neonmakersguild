DROP procedure IF EXISTS userimages_search;

delimiter ;;

CREATE PROCEDURE userimages_search(
  IN _uiid     INT(11),
  IN _usid     INT(11),
  IN _ratio    FLOAT,
  IN _term     VARCHAR(20),
  IN _paging   VARCHAR(50)
)
BEGIN
  DECLARE _limit INT(11) DEFAULT get_page_data(_paging, 'limit');
  DECLARE _offset INT(11) DEFAULT get_page_data(_paging, 'offset');

  SELECT SQL_CALC_FOUND_ROWS *
    FROM userimages
   WHERE (_uiid IS NULL OR ui_uiid = _uiid)
     AND (_usid IS NULL OR ui_usid = _usid)
     AND (_ratio IS NULL OR round(ui_width/ui_height,2) = _ratio)
     AND (_term IS NULL OR
           ui_filename REGEXP CONVERT(_term USING utf8) OR
           (LEFT(_term,1)='x' AND CONCAT('x', ui_height)=CONVERT(_term USING utf8)) OR
           (RIGHT(_term,1)='x' AND CONCAT(ui_width, 'x')=CONVERT(_term USING utf8)) OR
           round(ui_width/ui_height,2) = CONVERT(_term, DECIMAL)
         )
     ORDER BY ui_dla desc, ui_uiid desc
     LIMIT _limit OFFSET _offset;

  call pagination(FOUND_ROWS(), _limit, _offset, _term);
END;;

delimiter ;
