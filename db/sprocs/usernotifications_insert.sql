DROP procedure IF EXISTS usernotifications_insert;

delimiter ;;

CREATE PROCEDURE usernotifications_insert(
  IN _usid         INT,
  IN _type         VARCHAR(50),
  IN _ref_id       INT,
  IN _message      VARCHAR(255),
  IN _data         VARCHAR(1000),
  IN _read         TINYINT
)
BEGIN
  SET _read = IFNULL(_read, 0);
  INSERT INTO usernotifications (
    un_usid, un_type, un_ref_id, un_message, un_data, un_read, un_added
  ) VALUES (
    _usid, _type, _ref_id, _message, _data, _read, CURRENT_TIMESTAMP
  );

  CALL usernotifications_get_by_ids(LAST_INSERT_ID());
END;;

delimiter ;
