DROP procedure IF EXISTS forums_insert;

delimiter ;;

CREATE PROCEDURE forums_insert(
  IN _name          varchar(50),
  IN _alias         varchar(50),
  IN _description   varchar(255),
  IN _active        tinyint(1),
  IN _admin         tinyint(1),
  IN _private       tinyint(1),
  IN _order         int(11),
  IN _threads       int(11),
  IN _messages      int(11),
  IN _last_fmid     int(11)
)
BEGIN
  INSERT INTO forums (
    fo_name, fo_alias, fo_description, fo_active, fo_admin, fo_private,
    fo_order, fo_threads, fo_messages, fo_last_fmid
  ) VALUES (
    _name, _alias, _description, _active, _admin, _private,
    _order, _threads, _messages, _last_fmid
  );

  CALL forums_get_by_ids(LAST_INSERT_ID());
END;;

delimiter ;
