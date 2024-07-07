DROP procedure IF EXISTS forumthreads_list;

delimiter ;;

CREATE PROCEDURE forumthreads_list(
  IN _foid    INT(11),
  IN _deleted TINYINT(1),
  IN _term    VARCHAR(25),
  IN _paging  VARCHAR(50)
)
BEGIN
  DECLARE _limit INT(11) DEFAULT get_page_data(_paging, 'limit');
  DECLARE _offset INT(11) DEFAULT get_page_data(_paging, 'offset');
  SET _term = clean_regexp(_term);

  SELECT SQL_CALC_FOUND_ROWS forumthreads.*, users.*, forummessages.*,
         fo_alias, last_user.us_usid AS lus_usid, last_user.us_user AS lus_user
    FROM forumthreads
         INNER JOIN forums ON fo_foid = ft_foid
         INNER JOIN users ON users.us_usid = ft_usid
         LEFT OUTER JOIN forummessages ON fm_fmid = ft_last_fmid
         LEFT OUTER JOIN users AS last_user ON last_user.us_usid = fm_usid
   WHERE ft_foid = _foid
     AND (_deleted IS NULL OR (_deleted=0 AND ft_deleted IS NULL) OR (_deleted=1 AND ft_deleted IS NOT NULL))
     AND (_term IS NULL OR
           users.us_user = _term OR
           last_user.us_user = _term OR
           ft_subject REGEXP _term OR
           ft_alias REGEXP _term
         )
   ORDER BY ft_dla DESC, ft_ftid DESC
   LIMIT _limit OFFSET _offset;

  call pagination(FOUND_ROWS(), _limit, _offset, null);
END;;

delimiter ;
