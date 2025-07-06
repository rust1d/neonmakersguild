DROP procedure IF EXISTS blogentryimages_search;

delimiter ;;

CREATE PROCEDURE blogentryimages_search(
  IN _beiid         INT(11),
  IN _benid         INT(11),
  IN _uiid          INT(11),
  IN _nav           TINYINT
)
BEGIN
  IF _nav IS NOT NULL THEN -- PASS 1 TO GO NEXT, 0 TO GO PREV
    SET _beiid = bei_navigate(_beiid, _nav);
  END IF;

  SELECT blogentryimages.*, userimages.*, blogentries.*,
         (SELECT COUNT(*) FROM blogcomments WHERE bco_benid=ben_benid AND bco_beiid=0) AS ben_comment_cnt,
         (SELECT COUNT(*) FROM blogentryimages WHERE bei_benid=ben_benid) AS ben_image_cnt,
         (SELECT COUNT(*) FROM blogcomments WHERE bco_beiid=bei_beiid) AS bei_comment_cnt
    FROM blogentryimages
         INNER JOIN blogentries ON ben_benid=bei_benid
         INNER JOIN userimages ON ui_uiid=bei_uiid
   WHERE (_beiid IS NULL OR bei_beiid = _beiid)
     AND (_benid IS NULL OR bei_benid = _benid)
     AND (_uiid IS NULL OR bei_uiid = _uiid);
END;;

delimiter ;
