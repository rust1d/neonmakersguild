DROP procedure IF EXISTS forums_update;

delimiter ;;

CREATE PROCEDURE forums_update(
  IN _foid          int(11),
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
  UPDATE forums
     SET fo_name        = IFNULL(_name,        fo_name),
         fo_alias       = IFNULL(_alias,       fo_alias),
         fo_description = IFNULL(_description, fo_description),
         fo_active      = IFNULL(_active,      fo_active),
         fo_admin       = IFNULL(_admin,       fo_admin),
         fo_private     = IFNULL(_private,     fo_private),
         fo_order       = IFNULL(_order,       fo_order),
         fo_threads     = IFNULL(_threads,     fo_threads),
         fo_messages    = IFNULL(_messages,    fo_messages),
         fo_last_fmid   = IFNULL(_last_fmid,   fo_last_fmid)
   WHERE fo_foid = _foid;

  CALL forums_get_by_ids(_foid);
END;;

delimiter ;
