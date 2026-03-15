DROP procedure IF EXISTS events_search;

delimiter ;;

CREATE PROCEDURE events_search(
  IN _evid      int(11) unsigned,
  IN _usid      int(11),
  IN _google_id varchar(200),
  IN _term      varchar(25),
  IN _paging    varchar(50)
)
BEGIN
  DECLARE _limit INT(11) DEFAULT get_page_data(_paging, 'limit');
  DECLARE _offset INT(11) DEFAULT get_page_data(_paging, 'offset');
  SET _term = clean_regexp(_term);

  SELECT SQL_CALC_FOUND_ROWS *
    FROM events
   WHERE (_evid IS NULL OR ev_evid = _evid)
     AND (_usid IS NULL OR ev_usid = _usid)
     AND (_google_id IS NULL OR ev_google_id = _google_id)
     AND (_term IS NULL OR
           ev_summary REGEXP _term OR
           ev_location REGEXP _term OR
           ev_description REGEXP _term)
   ORDER BY ev_start desc
   LIMIT _limit OFFSET _offset;

  call pagination(FOUND_ROWS(), _limit, _offset, _term);
END;;

delimiter ;
