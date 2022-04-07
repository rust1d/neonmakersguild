/* CREATE SCHEMA neonmakersguild ; */

DROP TABLE IF EXISTS users;

CREATE TABLE users (
  us_usid        INT(11) NOT NULL AUTO_INCREMENT,
  us_user        VARCHAR(50) NOT NULL,
  us_password    VARCHAR(100) NOT NULL,
  us_email       VARCHAR(50) NOT NULL,
  us_permissions TINYINT(4) DEFAULT 0,
  us_active      TINYINT(1) DEFAULT 1,
  us_deleted     TINYINT(1) DEFAULT 0,
  us_added       DATETIME DEFAULT CURRENT_TIMESTAMP,
  us_dla         DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (us_usid),
  UNIQUE INDEX (us_email)
) ENGINE=InnoDB;

insert into users (us_user, us_password, us_email, us_permissions) values ('rust1d', '$2a$10$Uf0dppN2Zi94EDz.vC.Y2OLXwDt8c53eMzkY/mRlrkANU2mrGSssm', 'rust1d@usa.net', 2);

DROP TABLE IF EXISTS userProfile;

CREATE TABLE userProfile (
  up_upid        INT(11) NOT NULL AUTO_INCREMENT,
  up_usid        INT(11) NOT NULL,
  up_firstname   VARCHAR(50),
  up_lastname    VARCHAR(50),
  up_bio         TEXT,
  up_location    VARCHAR(100),
  up_dla         DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (up_upid),
  UNIQUE INDEX (up_usid)
) ENGINE=InnoDB;

CREATE TABLE userImages (
  ui_uiid        INT(11) NOT NULL AUTO_INCREMENT,
  ui_usid        INT(11) NOT NULL,
  ui_width       INT(11),
  ui_height      INT(11),
  ui_size        INT(11),
  ui_filename    VARCHAR(100),
  ui_type        VARCHAR(10),
  ui_dla         DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (ui_uiid),
  INDEX (ui_usid) USING BTREE
) ENGINE=InnoDB;

CREATE TABLE userLinks (
  ul_ulid        INT(11) NOT NULL AUTO_INCREMENT,
  ul_usid        INT(11) NOT NULL,
  ul_url         VARCHAR(200),
  ul_type        VARCHAR(10),
  ul_dla         DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (ul_ulid),
  INDEX (ul_usid) USING BTREE
) ENGINE=InnoDB;
