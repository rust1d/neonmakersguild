DROP procedure IF EXISTS forums_insert;

delimiter ;;

CREATE PROCEDURE forums_insert(
  IN _name          varchar(50),
  IN _alias         varchar(50),
  IN _description   varchar(255),
  IN _active        tinyint(1),
  IN _admin         tinyint(1),
  IN _order         int(11),
  IN _threads       int(11),
  IN _messages      int(11),
  IN _last_fmid     int(11)
)
BEGIN
  SET _threads = IFNULL(_threads, 0);
  SET _messages = IFNULL(_messages, 0);
  SET _admin = IFNULL(_admin, 0);
  SET _order = IFNULL(_order, 0);

  INSERT INTO forums (
    fo_name, fo_alias, fo_description, fo_active, fo_threads, fo_messages, fo_last_fmid
  ) VALUES (
    _name, _alias, _description, _active, _threads, _messages, _last_fmid
  );

  CALL forums_get_by_ids(LAST_INSERT_ID());
END;;

delimiter ;
