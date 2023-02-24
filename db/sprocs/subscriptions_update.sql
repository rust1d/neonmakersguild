DROP procedure IF EXISTS subscriptions_update;

delimiter ;;

CREATE PROCEDURE subscriptions_update(
  IN _ssid    int(11),
  IN _usid    int(11),
  IN _fkey    int(11),
  IN _table   varchar(20)
)
BEGIN
  UPDATE subscriptions
     SET ss_usid  = IFNULL(_usid,  ss_usid),
         ss_fkey  = IFNULL(_fkey,  ss_fkey),
         ss_table = IFNULL(_table, ss_table)
   WHERE ss_ssid = _ssid;

  CALL subscriptions_get_by_ids(_ssid);
END;;

delimiter ;
