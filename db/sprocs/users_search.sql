DROP procedure IF EXISTS users_search;

delimiter ;;

CREATE PROCEDURE users_search(
  IN _usid     INT(11),
  IN _user     VARCHAR(50),
  IN _email    VARCHAR(50),
  IN _deleted  TINYINT(1),
  IN _pastdue  INT(11),
  IN _term     VARCHAR(25),
  IN _paging   VARCHAR(50)
)
BEGIN
  DECLARE _limit INT(11) DEFAULT get_page_data(_paging, 'limit');
  DECLARE _offset INT(11) DEFAULT get_page_data(_paging, 'offset');
  DECLARE _last_year DATE DEFAULT DATE_ADD(NOW(), INTERVAL -1 YEAR);
  SET _term = clean_regexp(_term);

  SELECT SQL_CALC_FOUND_ROWS *
    FROM users
         INNER JOIN userprofile ON up_usid = us_usid
   WHERE (_usid IS NULL OR us_usid = _usid)
     AND (_user IS NULL OR us_user = CONVERT(_user USING latin1))
     AND (_email IS NULL OR us_email = CONVERT(_email USING latin1))
     AND (_deleted IS NULL OR (_deleted = 0 AND us_deleted IS NULL) OR (_deleted = 1 AND us_deleted IS NOT NULL))
     AND (_pastdue IS NULL OR
           (_pastdue > 0 AND datediff(now(), nextrenewal(us_renewal)) BETWEEN 0 AND _pastdue) OR
           (_pastdue < 0 AND datediff(nextrenewal(us_renewal), now()) BETWEEN 1 AND -_pastdue)
         )
     AND (_term IS NULL OR
           us_user = _term OR
           up_firstname REGEXP _term OR
           up_lastname REGEXP _term OR
           up_location REGEXP _term OR
           up_bio REGEXP _term
         )
   ORDER BY CASE WHEN _pastdue IS NULL AND datediff(_last_year, us_renewal) < 0 THEN 0 ELSE datediff(_last_year, us_renewal) END, us_usid
     LIMIT _limit OFFSET _offset;

  call pagination(FOUND_ROWS(), _limit, _offset, _term);
END;;

delimiter ;
