DROP PROCEDURE IF EXISTS create_temp_table_id_list;

delimiter ;;

CREATE PROCEDURE create_temp_table_id_list(
  IN _ids TEXT
)
BEGIN
  DECLARE id INT;
  DECLARE pos INT DEFAULT INSTR(_ids, ',');

  DROP TEMPORARY TABLE IF EXISTS _id_list;
  CREATE TEMPORARY TABLE _id_list (_il_id INT PRIMARY KEY);

  IF LENGTH(_ids) THEN
    WHILE pos > 0 DO
      INSERT INTO _id_list VALUES (SUBSTRING_INDEX(_ids, ',', 1));
      SET _ids = MID(_ids, pos + 1, CHAR_LENGTH(_ids));
      SET pos = INSTR(_ids, ',');
    END WHILE;
    INSERT INTO _id_list VALUES (_ids);
  END IF;
END
;;

delimiter ;
