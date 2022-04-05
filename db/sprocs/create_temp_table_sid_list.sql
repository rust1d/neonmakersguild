DROP PROCEDURE IF EXISTS create_temp_table_sid_list;

delimiter ;;

CREATE PROCEDURE create_temp_table_sid_list(
  IN _ids TEXT
)
BEGIN
  DECLARE pos INT DEFAULT INSTR(_ids, ',');

  DROP TEMPORARY TABLE IF EXISTS _sid_list;
  CREATE TEMPORARY TABLE _sid_list (_il_sid VARCHAR(10) PRIMARY KEY);

  IF LENGTH(_ids) THEN
    WHILE pos > 0 DO
      INSERT INTO _sid_list VALUES (SUBSTRING_INDEX(_ids, ',', 1));
      SET _ids = MID(_ids, pos + 1, CHAR_LENGTH(_ids));
      SET pos = INSTR(_ids, ',');
    END WHILE;
    INSERT INTO _sid_list VALUES (_ids);
  END IF;
END
;;

delimiter ;
