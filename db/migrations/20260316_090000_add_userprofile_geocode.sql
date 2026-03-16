ALTER TABLE userprofile
  ADD COLUMN up_latitude  DECIMAL(10,7) NULL AFTER up_country,
  ADD COLUMN up_longitude DECIMAL(10,7) NULL AFTER up_latitude
;
