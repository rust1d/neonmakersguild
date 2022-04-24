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
  us_dll         DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (us_usid),
  UNIQUE INDEX (us_email)
) ENGINE=InnoDB;

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


DROP TABLE IF EXISTS userImages;

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


DROP TABLE IF EXISTS BlogCategories;

CREATE TABLE BlogCategories (
  bca_bcaid                             INT(11) NOT NULL AUTO_INCREMENT,
  bca_blog                              INT(11) NOT NULL,
  bca_category                          VARCHAR(50),
  bca_alias                             VARCHAR(50),
  PRIMARY KEY (bca_bcaid),
  KEY(bca_blog),
  KEY(bca_category),
  KEY(bca_alias)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS BlogComments;

CREATE TABLE BlogComments (
  bco_bcoid                             INT(11) NOT NULL AUTO_INCREMENT,
  bco_blog                              INT(11) NOT NULL,
  bco_benid                             INT(11) NOT NULL,
  bco_usid                              INT(11),
  bco_comment                           TEXT,
  bco_history                           TEXT,
  bco_added                             DATETIME,
  bco_dla                               DATETIME,
  PRIMARY KEY (bco_bcoid),
  KEY(bco_blog),
  KEY(bco_benid),
  KEY(bco_usid)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS BlogEntries;

CREATE TABLE BlogEntries (
  ben_benid                             INT(11) NOT NULL AUTO_INCREMENT,
  ben_blog                              INT(11) NOT NULL,
  ben_usid                              INT(11) NOT NULL,
  ben_posted                            DATETIME,
  ben_title                             VARCHAR(100),
  ben_alias                             VARCHAR(100),
  ben_image                             VARCHAR(150),
  ben_body                              LONGTEXT,
  ben_morebody                          LONGTEXT,
  ben_comments                          TINYINT(1),
  ben_views                             INT(11) unsigned,
  ben_released                          TINYINT(1),
  ben_promoted                          TINYINT(1),
  PRIMARY KEY (ben_benid),
  KEY(ben_blog),
  KEY(ben_usid),
  KEY(ben_posted),
  KEY(ben_title),
  KEY(ben_alias),
  KEY(ben_released)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS BlogEntriesCategories;

CREATE TABLE BlogEntriesCategories (
  bec_becid                             INT(11) NOT NULL AUTO_INCREMENT,
  bec_benid                             INT(11) NOT NULL,
  bec_bcaid                             INT(11) NOT NULL,
  PRIMARY KEY (bec_becid),
  KEY(bec_benid),
  KEY(bec_bcaid)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS BlogEntriesRelated;

/* CREATE TABLE BlogEntriesRelated (
  bre_breid                             INT(11) NOT NULL AUTO_INCREMENT,
  bre_benid                             INT(11) NOT NULL,
  bre_relbenid                          INT(11) NOT NULL,
  PRIMARY KEY (bre_breid),
  KEY(bre_benid),
  KEY(bre_relbenid)
) ENGINE=InnoDB DEFAULT CHARSET=utf8; */


DROP TABLE IF EXISTS BlogLinks;

CREATE TABLE BlogLinks (
  bli_bliid                             INT(11) NOT NULL AUTO_INCREMENT,
  bli_blog                              INT(11) NOT NULL,
  bli_type                              VARCHAR(20),
  bli_url                               VARCHAR(200),
  bli_title                             VARCHAR(100),
  bli_description                       VARCHAR(200),
  PRIMARY KEY (bli_bliid),
  INDEX (bli_blog) USING BTREE
) ENGINE=InnoDB;


DROP TABLE IF EXISTS BlogPages;

CREATE TABLE BlogPages (
  bpa_bpaid                             INT(11) NOT NULL AUTO_INCREMENT,
  bpa_blog                              INT(11) NOT NULL,
  bpa_title                             VARCHAR(100),
  bpa_alias                             VARCHAR(100),
  bpa_body                              LONGTEXT,
  bpa_standalone                        TINYINT(1) NOT NULL default '0',
  PRIMARY KEY (bpa_bpaid),
  KEY(bpa_blog),
  KEY(bpa_alias),
  KEY(bpa_title)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;


DROP TABLE IF EXISTS BlogSearchStats;

DROP TABLE IF EXISTS BlogSubscribers;

CREATE TABLE BlogSubscribers (
  bsu_bsuid                             INT(11) NOT NULL AUTO_INCREMENT,
  bsu_blog                              INT(11) NOT NULL,
  bsu_email                             VARCHAR(50),
  bsu_verified                          TINYINT(1),
  PRIMARY KEY (bsu_bsuid),
  KEY(bsu_blog),
  KEY(bsu_email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS BlogTextBlocks;

CREATE TABLE BlogTextBlocks (
  btb_btbid                             INT(11) NOT NULL AUTO_INCREMENT,
  btb_blog                              INT(11) NOT NULL,
  btb_label                             VARCHAR(100),
  btb_body                              LONGTEXT,
  PRIMARY KEY (btb_btbid),
  KEY(btb_blog),
  KEY(btb_label)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;


DROP TABLE IF EXISTS BlogRoles;

CREATE TABLE BlogRoles (
  bro_broid                             INT(11) NOT NULL AUTO_INCREMENT,
  bro_role                              VARCHAR(50),
  bro_description                       VARCHAR(255),
  PRIMARY KEY (bro_broid),
  KEY(bro_role)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS BlogUserRoles;

CREATE TABLE BlogUserRoles (
  bur_burid                             INT(11) NOT NULL AUTO_INCREMENT,
  bur_usid                              INT(11) NOT NULL,
  bur_broid                             INT(11) NOT NULL,
  bur_blog                              INT(11) NOT NULL,
  PRIMARY KEY (bur_burid),
  KEY(bur_blog),
  KEY(bur_usid),
  KEY(bur_broid)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS BlogPagesCategories;

CREATE TABLE BlogPagesCategories  (
  bpc_bpcid                             INT(11) NOT NULL AUTO_INCREMENT,
  bpc_bpaid                             INT(11) NOT NULL,
  bpc_bcaid                             INT(11) NOT NULL,
  PRIMARY KEY (bpc_bpcid),
  KEY(bpc_bpaid),
  KEY(bpc_bcaid)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ;
