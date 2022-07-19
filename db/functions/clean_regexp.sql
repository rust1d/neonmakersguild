DROP FUNCTION IF EXISTS clean_regexp;

delimiter ;;

CREATE FUNCTION clean_regexp(_string VARCHAR(255)) RETURNS VARCHAR(255) DETERMINISTIC
BEGIN
  DECLARE _temp INT;

  DECLARE CONTINUE HANDLER FOR 1139 BEGIN
    SET _string = NULL;
  END;

  IF _string IS NOT NULL THEN
    SET _string = CONVERT(_string USING utf8);
    SELECT '' REGEXP(_string) INTO _temp;
  END IF;

  RETURN _string;
END
;;

delimiter ;
