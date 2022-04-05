DROP FUNCTION IF EXISTS config_get_by_key;

DELIMITER ;;

CREATE FUNCTION config_get_by_key(
  _key VARCHAR(200)
) RETURNS VARCHAR(500)
READS SQL DATA
DETERMINISTIC
BEGIN
  DECLARE _group VARCHAR(50);
  DECLARE _value VARCHAR(500);

  IF INSTR(_key, '.') THEN
    SET _group = SUBSTRING_INDEX(_key, '.', 1);
    SET _key = TRIM('.' FROM REPLACE(_key, _group, ''));
  END IF;

  SELECT cfg_value INTO _value
    FROM configurations
   WHERE cfg_group = COALESCE(_group, cfg_group)
     AND cfg_key = _key;

  RETURN _value;
END
;;
delimiter ;
