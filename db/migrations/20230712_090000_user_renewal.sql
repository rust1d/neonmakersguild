-- ALTER TABLE USERS DROP COLUMN us_renewal;

ALTER TABLE USERS
  ADD COLUMN us_renewal DATE AFTER us_permissions
;

UPDATE users
   SET us_renewal = Date_Add(date_format(us_added, '%Y-%m-01'), INTERVAL 1 MONTH);

UPDATE users
  SET us_renewal = Date_Add(date_format(us_added, '%Y-%m-01'), INTERVAL 10 YEAR)
 WHERE us_usid < 8;
