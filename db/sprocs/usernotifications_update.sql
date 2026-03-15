DROP procedure IF EXISTS usernotifications_update;

delimiter ;;

CREATE PROCEDURE usernotifications_update(
  IN _unid         INT,
  IN _usid         INT,
  IN _type         VARCHAR(50),
  IN _ref_id       INT,
  IN _message      VARCHAR(255),
  IN _data         VARCHAR(1000),
  IN _read         TINYINT
)
BEGIN
  UPDATE usernotifications
     SET un_usid       = IFNULL(_usid,       un_usid),
         un_type       = IFNULL(_type,       un_type),
         un_ref_id     = IFNULL(_ref_id,     un_ref_id),
         un_message    = IFNULL(_message,    un_message),
         un_data       = IFNULL(_data,       un_data),
         un_read       = IFNULL(_read,       un_read)
   WHERE un_unid = _unid;

  CALL usernotifications_get_by_ids(_unid);
END;;

delimiter ;
