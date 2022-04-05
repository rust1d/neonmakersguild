DROP FUNCTION IF EXISTS list_first;

delimiter ;;

CREATE FUNCTION list_first(
  _string VARCHAR(255),
  _delim  VARCHAR(1)
) RETURNS VARCHAR(255)
BEGIN
  RETURN SUBSTRING_INDEX(_string, _delim, 1);
END
;;

delimiter ;
