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
  ben_usid                              INT(11),
  bco_name                              VARCHAR(50),
  bco_email                             VARCHAR(50),
  bco_comment                           TEXT,
  bco_posted                            DATETIME,
  bco_subscribe                         TINYINT(1),
  bco_website                           VARCHAR(255),
  bco_moderated                         TINYINT(1),
  bco_subscribeonly                     TINYINT(1),
  bco_kill                              VARCHAR(35),
  PRIMARY KEY (bco_bcoid),
  KEY(bco_blog),
  KEY(bco_benid),
  KEY(bco_posted),
  KEY(bco_moderated),
  KEY(bco_email),
  KEY(bco_name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS BlogEntries;

CREATE TABLE BlogEntries (
  ben_benid                             INT(11) NOT NULL AUTO_INCREMENT,
  ben_blog                              INT(11) NOT NULL,
  ben_usid                              INT(11) NOT NULL,
  ben_title                             VARCHAR(100),
  ben_body                              LONGTEXT,
  ben_posted                            DATETIME,
  ben_morebody                          LONGTEXT,
  ben_alias                             VARCHAR(100),
  ben_allowcomments                     TINYINT(1),
  ben_attachment                        VARCHAR(255),
  ben_filesize                          INT(11) unsigned,
  ben_mimetype                          VARCHAR(255),
  ben_views                             INT(11) unsigned,
  ben_released                          TINYINT(1),
  ben_mailed                            TINYINT(1),
  /* ben_summary                           VARCHAR(255),
  ben_subtitle                          VARCHAR(100),
  ben_keywords                          VARCHAR(100),
  ben_duration                          VARCHAR(10), */
  PRIMARY KEY (ben_benid),
  KEY(ben_blog),
  KEY(ben_released),
  KEY(ben_posted),
  KEY(ben_title),
  KEY(ben_usid),
  KEY(ben_alias)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS BlogEntriesCategories;

CREATE TABLE BlogEntriesCategories (
  bec_becid                             INT(11) NOT NULL AUTO_INCREMENT,
  bec_benid                             INT(11) NOT NULL,
  bec_bcaid                             INT(11) NOT NULL,
  PRIMARY KEY (bec_becid),
  KEY(bec_benid, bec_bcaid)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;


DROP TABLE IF EXISTS BlogEntriesRelated;

CREATE TABLE BlogEntriesRelated (
  bre_breid                             INT(11) NOT NULL AUTO_INCREMENT,
  bre_benid                             INT(11) NOT NULL,
  bre_relbenid                          INT(11) NOT NULL,
  PRIMARY KEY (bre_breid),
  KEY(bre_benid),
  KEY(bre_relbenid)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;


DROP TABLE IF EXISTS BlogPages;

CREATE TABLE BlogPages (
  bpa_bpaid                             INT(11) NOT NULL AUTO_INCREMENT,
  bpa_blog                              INT(11) NOT NULL,
  bpa_title                             VARCHAR(255),
  bpa_alias                             VARCHAR(100),
  bpa_body                              LONGTEXT,
  bpa_showlayout                        TINYINT(1) NOT NULL default '0',
  PRIMARY KEY (bpa_bpaid),
  KEY(bpa_blog),
  KEY(bpa_alias),
  KEY(bpa_title)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;


DROP TABLE IF EXISTS BlogSearchStats;

CREATE TABLE BlogSearchStats (
  bss_term                              VARCHAR(255),
  bss_searched                          DATETIME,
  bss_blog                              VARCHAR(50)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;


DROP TABLE IF EXISTS BlogSubscribers;

CREATE TABLE BlogSubscribers (
  bsu_bsuid                             INT(11) NOT NULL AUTO_INCREMENT,
  bsu_email                             VARCHAR(50),
  bsu_token                             VARCHAR(35),
  bsu_blog                              INT(11) NOT NULL,
  bsu_verified                          TINYINT(1),
  PRIMARY KEY (bsu_bsuid),
  KEY(bsu_blog),
  KEY(bsu_verified),
  KEY(bsu_email),
  KEY(bsu_token)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;


DROP TABLE IF EXISTS BlogTextBlocks;

CREATE TABLE BlogTextBlocks (
  btb_btbid                             INT(11) NOT NULL AUTO_INCREMENT,
  btb_label                             VARCHAR(255),
  btb_body                              LONGTEXT,
  btb_blog                              INT(11) NOT NULL,
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

INSERT INTO BlogRoles (bro_role, bro_description) VALUES
 ('AddCategory', 'The ability to create a new category when editing a blog entry.'),
 ('ManageCategories', 'The ability to manage blog categories.'),
 ('Admin', 'A special role for the admin. Allows all functionality.'),
 ('ManageUsers', 'The ability to manage blog users.'),
 ('ReleaseEntries', 'The ability to both release a new entry and edit any released entry.');

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

INSERT INTO BlogUserRoles(bur_usid,bur_broid,bur_blog) VALUES (1,3,1);


DROP TABLE IF EXISTS BlogPagesCategories;

CREATE TABLE BlogPagesCategories  (
  bpc_bpcid                             INT(11) NOT NULL AUTO_INCREMENT,
  bpc_bcaid                             INT(11) NOT NULL,
  bpc_bpaid                             INT(11) NOT NULL,
  PRIMARY KEY (bpc_bpcid)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ;
