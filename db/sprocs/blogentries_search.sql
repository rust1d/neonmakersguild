DROP procedure IF EXISTS blogentries_search;

delimiter ;;

CREATE PROCEDURE blogentries_search(
  IN _benid       int(11),
  IN _blog        int(11),
  IN _usid        int(11),
  IN _title       varchar(100),
  IN _posted      datetime,
  IN _alias       varchar(100),
  IN _released    tinyint(1)
)
BEGIN
  SELECT *
    FROM blogentries
   WHERE (_benid IS NULL OR ben_benid = _benid)
     AND (_blog IS NULL OR ben_blog = _blog)
     AND (_usid IS NULL OR ben_usid = _usid)
     AND (_title IS NULL OR ben_title = _title)
     AND (_posted IS NULL OR ben_posted = _posted)
     AND (_alias IS NULL OR ben_alias = _alias)
     AND (_released IS NULL OR ben_released = _released);
END;;

delimiter ;
