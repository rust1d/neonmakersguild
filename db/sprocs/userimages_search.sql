DROP procedure IF EXISTS userimages_search;

delimiter ;;

CREATE PROCEDURE userimages_search(
  IN _uiid   int(11),
  IN _usid   int(11)
)
BEGIN
  SELECT *
    FROM userimages
   WHERE (_uiid IS NULL OR ui_uiid = _uiid)
     AND (_usid IS NULL OR ui_usid = _usid);
END;;

delimiter ;
