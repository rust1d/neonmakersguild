-- DROP TABLE IF EXISTS users;

-- alter table users drop column us_active;
-- alter table users drop column us_deleted;
-- alter table users add column us_deleted datetime after us_permissions;

CREATE TABLE users (
  us_usid        INT(11) NOT NULL AUTO_INCREMENT,
  us_user        VARCHAR(50) NOT NULL,
  us_password    VARCHAR(100) NOT NULL,
  us_email       VARCHAR(50) NOT NULL,
  us_permissions TINYINT(4) DEFAULT 0,
  us_deleted     DATETIME,
  us_added       DATETIME DEFAULT CURRENT_TIMESTAMP,
  us_dla         DATETIME DEFAULT CURRENT_TIMESTAMP,
  us_dll         DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (us_usid),
  UNIQUE INDEX (us_email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- DROP TABLE IF EXISTS userProfile;

CREATE TABLE userProfile (
  up_upid        INT(11) NOT NULL AUTO_INCREMENT,
  up_usid        INT(11) NOT NULL,
  up_firstname   VARCHAR(50),
  up_lastname    VARCHAR(50),
  up_bio         TEXT,
  up_location    VARCHAR(100),
  up_phone       VARCHAR(15),
  up_promo       VARCHAR(25),
  up_address1    VARCHAR(50),
  up_address2    VARCHAR(25),
  up_city        VARCHAR(25),
  up_region      VARCHAR(25),
  up_postal      VARCHAR(12),
  up_country     VARCHAR(2),
  up_dla         DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (up_upid),
  UNIQUE INDEX (up_usid)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- alter table userProfile add column up_phone VARCHAR(15) after up_location;
-- alter table userProfile add column up_promo VARCHAR(25) after up_phone;
--  ALTER TABLE userProfile ADD COLUMN up_address1  VARCHAR(50) AFTER up_promo;
--  ALTER TABLE userProfile ADD COLUMN up_address2  VARCHAR(25) AFTER up_address1;
--  ALTER TABLE userProfile ADD COLUMN up_city      VARCHAR(25) AFTER up_address2;
--  ALTER TABLE userProfile ADD COLUMN up_region    VARCHAR(25) AFTER up_city;
--  ALTER TABLE userProfile ADD COLUMN up_postal    VARCHAR(12) AFTER up_region;
--  ALTER TABLE userProfile ADD COLUMN up_country   VARCHAR(2)  AFTER up_postal;



-- DROP TABLE IF EXISTS userImages;

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- DROP TABLE IF EXISTS BlogCategories;

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


-- DROP TABLE IF EXISTS BlogComments;

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


-- DROP TABLE IF EXISTS BlogEntries;

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
  ben_views                             INT(11),
  ben_released                          TINYINT(1),
  ben_promoted                          DATETIME,
  ben_added                             DATETIME,
  ben_dla                               DATETIME,
  PRIMARY KEY (ben_benid),
  KEY(ben_blog),
  KEY(ben_usid),
  KEY(ben_posted),
  KEY(ben_title),
  KEY(ben_alias),
  KEY(ben_released)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- alter table BlogEntries add column ben_added datetime after ben_promoted;
-- alter table BlogEntries add column ben_dla datetime after ben_added;
-- update blogentries set ben_added = ben_posted, ben_dla = ben_posted

-- ALTER TABLE BlogEntries DROP COLUMN ben_promoted;
-- ALTER TABLE BlogEntries ADD COLUMN ben_promoted DATETIME after ben_released;


-- DROP TABLE IF EXISTS BlogEntriesCategories;

CREATE TABLE BlogEntriesCategories (
  bec_becid                             INT(11) NOT NULL AUTO_INCREMENT,
  bec_benid                             INT(11) NOT NULL,
  bec_bcaid                             INT(11) NOT NULL,
  PRIMARY KEY (bec_becid),
  KEY(bec_benid),
  KEY(bec_bcaid)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- DROP TABLE IF EXISTS BlogLinks;

CREATE TABLE BlogLinks (
  bli_bliid                             INT(11) NOT NULL AUTO_INCREMENT,
  bli_blog                              INT(11) NOT NULL,
  bli_type                              VARCHAR(20),
  bli_url                               VARCHAR(200),
  bli_title                             VARCHAR(100),
  bli_description                       VARCHAR(200),
  bli_clicks                            INT(11) NOT NULL DEFAULT 0,
  bli_dla                               DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (bli_bliid),
  INDEX (bli_blog) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- DROP TABLE IF EXISTS BlogPages;

CREATE TABLE BlogPages (
  bpa_bpaid                             INT(11) NOT NULL AUTO_INCREMENT,
  bpa_blog                              INT(11) NOT NULL,
  bpa_title                             VARCHAR(100),
  bpa_alias                             VARCHAR(100),
  bpa_body                              LONGTEXT,
  bpa_standalone                        TINYINT(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (bpa_bpaid),
  KEY(bpa_blog),
  KEY(bpa_alias),
  KEY(bpa_title)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;


-- DROP TABLE IF EXISTS BlogSubscribers;

CREATE TABLE BlogSubscribers (
  bsu_bsuid                             INT(11) NOT NULL AUTO_INCREMENT,
  bsu_blog                              INT(11) NOT NULL,
  bsu_email                             VARCHAR(50),
  bsu_verified                          TINYINT(1),
  PRIMARY KEY (bsu_bsuid),
  KEY(bsu_blog),
  KEY(bsu_email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- DROP TABLE IF EXISTS BlogTextBlocks;

CREATE TABLE BlogTextBlocks (
  btb_btbid                             INT(11) NOT NULL AUTO_INCREMENT,
  btb_blog                              INT(11) NOT NULL,
  btb_label                             VARCHAR(100),
  btb_body                              LONGTEXT,
  PRIMARY KEY (btb_btbid),
  KEY(btb_blog),
  KEY(btb_label)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;


-- DROP TABLE IF EXISTS BlogRoles;

CREATE TABLE BlogRoles (
  bro_broid                             INT(11) NOT NULL AUTO_INCREMENT,
  bro_role                              VARCHAR(50),
  bro_description                       VARCHAR(255),
  PRIMARY KEY (bro_broid),
  KEY(bro_role)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- DROP TABLE IF EXISTS BlogUserRoles;

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


-- DROP TABLE IF EXISTS BlogPagesCategories;

CREATE TABLE BlogPagesCategories  (
  bpc_bpcid                             INT(11) NOT NULL AUTO_INCREMENT,
  bpc_bpaid                             INT(11) NOT NULL,
  bpc_bcaid                             INT(11) NOT NULL,
  PRIMARY KEY (bpc_bpcid),
  KEY(bpc_bpaid),
  KEY(bpc_bcaid)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ;


-- DROP TABLE IF EXISTS forums;

CREATE TABLE forums (
  fo_foid                    INT(11) NOT NULL AUTO_INCREMENT,
  fo_name                    VARCHAR(50) NOT NULL,
  fo_alias                   VARCHAR(50) NOT NULL,
  fo_description             VARCHAR(255) NOT NULL,
  fo_active                  TINYINT(1) DEFAULT 1,
  fo_admin                   TINYINT(1) DEFAULT 0,
  fo_order                   INT(11) DEFAULT 0,
  fo_threads                 INT(11) DEFAULT 0,
  fo_messages                INT(11) DEFAULT 0,
  fo_last_fmid               INT(11),
  PRIMARY KEY (fo_foid),
  KEY (fo_last_fmid)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/* alter table forums add column fo_admin tinyint after fo_active default 0;
alter table forums add column fo_order tinyint after fo_admin; */


-- DROP TABLE IF EXISTS forumThreads;

CREATE TABLE forumThreads (
  ft_ftid                    INT(11) NOT NULL AUTO_INCREMENT,
  ft_foid                    INT(11) NOT NULL,
  ft_usid                    INT(11) NOT NULL,
  ft_subject                 VARCHAR(100) NOT NULL,
  ft_alias                   VARCHAR(100) NOT NULL,
  ft_sticky                  TINYINT(1) DEFAULT 0,
  ft_locked                  TINYINT(1) DEFAULT 0,
  ft_messages                INT(11) DEFAULT 0,
  ft_views                   INT(11) DEFAULT 0,
  ft_last_fmid               INT(11),
  ft_deleted_by              INT(11),
  ft_deleted                 DATETIME,
  ft_added                   DATETIME DEFAULT CURRENT_TIMESTAMP,
  ft_dla                     DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (ft_ftid),
  KEY (ft_foid),
  KEY (ft_usid)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;


-- DROP TABLE IF EXISTS forumMessages;

CREATE TABLE forumMessages (
  fm_fmid                    INT(11) NOT NULL AUTO_INCREMENT,
  fm_foid                    INT(11) NOT NULL,
  fm_ftid                    INT(11) NOT NULL,
  fm_usid                    INT(11) NOT NULL,
  fm_body                    TEXT,
  fm_history                 TEXT,
  fm_deleted_by              INT(11),
  fm_deleted                 DATETIME,
  fm_added                   DATETIME DEFAULT CURRENT_TIMESTAMP,
  fm_dla                     DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (fm_fmid),
  KEY (fm_foid),
  KEY (fm_ftid),
  KEY (fm_usid)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;


insert into forums (fo_name, fo_alias, fo_description) values ('Bending Forum', 'bending', 'for benderings.'),  ('Pumping Forum', 'Pumping', 'for pumperings.');


-- DROP TABLE IF EXISTS tags;

CREATE TABLE tags (
  tag_tagid  INT(11) NOT NULL AUTO_INCREMENT,
  tag_blog   INT(11),
  tag_tag    VARCHAR(25) DEFAULT NULL,
  PRIMARY KEY (tag_tagid),
  KEY (tag_blog),
  UNIQUE INDEX (tag_tag)
) ENGINE=InnoDB;

-- DROP TABLE IF EXISTS documents;

CREATE TABLE documents (
  doc_docid        INT(11) NOT NULL AUTO_INCREMENT,
  doc_blog         INT(11),
  doc_type         VARCHAR(10),
  doc_filename     VARCHAR(100),
  doc_description  VARCHAR(500),
  doc_size         INT(11),
  doc_views        INT(11) NOT NULL DEFAULT 0,
  doc_downloads    INT(11) NOT NULL DEFAULT 0,
  doc_added        DATETIME DEFAULT NULL,
  doc_dla          DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (doc_docid) USING BTREE,
  KEY (doc_blog)
) ENGINE = InnoDB;

-- alter table documents drop column doc_clicks;
-- alter table documents add column doc_views int(11) after doc_size;
-- alter table documents add column doc_downloads int(11) after doc_views;


-- DROP TABLE IF EXISTS documentTags;

CREATE TABLE documentTags (
  dt_dtid   INT(11) NOT NULL AUTO_INCREMENT,
  dt_docid  INT(11) NOT NULL,
  dt_tagid  INT(11) NOT NULL,
  PRIMARY KEY (dt_dtid),
  KEY (dt_docid),
  KEY (dt_tagid)
) ENGINE=InnoDB;

-- DROP TABLE IF EXISTS documentCategories;

CREATE TABLE documentCategories (
  dc_dcid          INT(11) NOT NULL AUTO_INCREMENT,
  dc_docid         INT(11) NOT NULL,
  dc_bcaid         INT(11) NOT NULL,
  PRIMARY KEY (dc_dcid),
  KEY(dc_docid),
  KEY(dc_bcaid)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- DROP TABLE IF EXISTS memberRequests;

CREATE TABLE memberRequests (
  mr_mrid          INT(11) NOT NULL AUTO_INCREMENT,
  mr_firstname     VARCHAR(50),
  mr_lastname      VARCHAR(50),
  mr_email         VARCHAR(50),
  mr_phone         VARCHAR(15),
  mr_location      VARCHAR(100),
  mr_website1      VARCHAR(200),
  mr_website2      VARCHAR(200),
  mr_history       TEXT,
  mr_promo         VARCHAR(25),
  mr_user          VARCHAR(50),
  mr_usid          INT(11),
  mr_deleted_by    INT(11),
  mr_deleted       DATETIME,
  mr_validated     DATETIME,
  mr_accepted      DATETIME,
  mr_added         DATETIME DEFAULT CURRENT_TIMESTAMP,
  mr_dla           DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (mr_mrid),
  KEY(mr_usid)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- alter table memberRequests add column mr_accepted DATETIME after mr_validated;