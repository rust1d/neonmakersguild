alter table memberRequests
  add column mr_address1    VARCHAR(50) after mr_location,
  add column mr_address2    VARCHAR(25) after mr_address1,
  add column mr_city        VARCHAR(25) after mr_address2,
  add column mr_region      VARCHAR(25) after mr_city,
  add column mr_postal      VARCHAR(12) after mr_region,
  add column mr_country     VARCHAR(2)  after mr_postal
;
