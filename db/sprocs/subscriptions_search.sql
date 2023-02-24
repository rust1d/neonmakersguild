DROP procedure IF EXISTS subscriptions_search;

delimiter ;;

CREATE PROCEDURE subscriptions_search(
  IN _ssid   int(11),
  IN _usid   int(11),
  IN _fkey   int(11),
  IN _table  varchar(20)
)
BEGIN
  SELECT *
    FROM subscriptions
   WHERE (_ssid IS NULL OR ss_ssid = _ssid)
     AND (_usid IS NULL OR ss_usid = _usid)
     AND (_fkey IS NULL OR ss_fkey = _fkey)
     AND (_table IS NULL OR ss_table = _table);
END;;

delimiter ;
