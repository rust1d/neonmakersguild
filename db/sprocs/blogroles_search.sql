DROP procedure IF EXISTS blogroles_search;

delimiter ;;

CREATE PROCEDURE blogroles_search(
  IN _broid    int(11),
  IN _role     varchar(50)
)
BEGIN
  SELECT *
    FROM blogroles
   WHERE (_broid IS NULL OR bro_broid = _broid)
     AND (_role IS NULL OR bro_role = _role);
END;;

delimiter ;
