DROP procedure IF EXISTS blogentries_search;

delimiter ;;

CREATE PROCEDURE blogentries_search(
  IN _benid       int(11),
  IN _blog        int(11),
  IN _usid        int(11),
  IN _title       varchar(100),
  IN _posted      datetime,
  IN _alias       varchar(100),
  IN _released    tinyint(1),
  IN _bcaid       int(11)
)
BEGIN
  SELECT blogentries.*, us_user AS ben_blogname
    FROM blogentries
         INNER JOIN users ON us_usid = ben_blog
   WHERE (_benid IS NULL OR ben_benid = _benid)
     AND (_blog IS NULL OR ben_blog = _blog)
     AND (_usid IS NULL OR ben_usid = _usid)
     AND (_title IS NULL OR ben_title = _title)
     AND (_posted IS NULL OR ben_posted = _posted)
     AND (_alias IS NULL OR ben_alias = _alias)
     AND (_released IS NULL OR ben_released = _released)
     AND (_bcaid IS NULL OR EXISTS (SELECT 1 FROM BlogEntriesCategories WHERE bec_bcaid=_bcaid AND bec_benid=ben_benid))
  ORDER BY ben_posted DESC, ben_benid DESC;
END;;

delimiter ;
