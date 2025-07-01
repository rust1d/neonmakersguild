DROP procedure IF EXISTS blogentryimages_search;

delimiter ;;

CREATE PROCEDURE blogentryimages_search(
  IN _beiid         int(11),
  IN _benid         int(11),
  IN _uiid          int(11)
)
BEGIN
  SELECT blogentryimages.*, userimages.*
    FROM blogentryimages
         INNER JOIN userimages ON ui_uiid=bei_uiid
   WHERE (_beiid IS NULL OR bei_beiid = _beiid)
     AND (_benid IS NULL OR bei_benid = _benid)
     AND (_uiid IS NULL OR bei_uiid = _uiid);
END;;

delimiter ;
