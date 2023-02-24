DROP procedure IF EXISTS subscriptions_insert;

delimiter ;;

CREATE PROCEDURE subscriptions_insert(
  IN _usid    int(11),
  IN _fkey    int(11),
  IN _table   varchar(20)
)
BEGIN
  INSERT INTO subscriptions (
    ss_usid, ss_table, ss_fkey, ss_added
  ) VALUES (
    _usid, _table, _fkey, CURRENT_TIMESTAMP
  );

  CALL subscriptions_get_by_ids(LAST_INSERT_ID());
END;;

delimiter ;
