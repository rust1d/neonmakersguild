DROP TABLE IF EXISTS BlogCategories;

CREATE TABLE BlogCategories (
  bca_bcaid                             VARCHAR(35) NOT NULL,
  bca_category                          VARCHAR(50),
  bca_alias                             VARCHAR(50),
  bca_blog                              VARCHAR(50),
  PRIMARY KEY (bca_bcaid),
  KEY(bca_alias),
  KEY(bca_category),
  KEY(bca_blog)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS BlogComments;

CREATE TABLE BlogComments (
  bco_bcoid                             VARCHAR(35) NOT NULL,
  bco_benid                             VARCHAR(35),
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
  KEY(bco_benid),
  KEY(bco_posted),
  KEY(bco_moderated),
  KEY(bco_email),
  KEY(bco_name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS BlogEntries;

CREATE TABLE BlogEntries (
  ben_benid                             VARCHAR(35) NOT NULL,
  ben_title                             VARCHAR(100),
  ben_body                              LONGTEXT,
  ben_posted                            DATETIME,
  ben_morebody                          LONGTEXT,
  ben_alias                             VARCHAR(100),
  ben_username                          VARCHAR(50),
  ben_blog                              VARCHAR(50),
  ben_allowcomments                     TINYINT(1),
  ben_enclosure                         VARCHAR(255),
  ben_filesize                          INT(11) unsigned,
  ben_mimetype                          VARCHAR(255),
  ben_views                             INT(11) unsigned,
  ben_released                          TINYINT(1),
  ben_mailed                            TINYINT(1),
  ben_summary                           VARCHAR(255),
  ben_subtitle                          VARCHAR(100),
  ben_keywords                          VARCHAR(100),
  ben_duration                          VARCHAR(10),
  PRIMARY KEY (ben_benid),
  KEY(ben_blog),
  KEY(ben_released),
  KEY(ben_posted),
  KEY(ben_title),
  KEY(ben_username),
  KEY(ben_alias)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS BlogEntriesCategories;

CREATE TABLE BlogEntriesCategories (
  bec_bcaid                             VARCHAR(35),
  bec_benid                             VARCHAR(35),
  KEY(bec_benid, bec_bcaid)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;


DROP TABLE IF EXISTS BlogEntriesRelated;

CREATE TABLE BlogEntriesRelated (
  bre_benid                             VARCHAR(35),
  bre_relbenid                          VARCHAR(35),
  KEY(bre_benid),
  KEY(bre_relbenid)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;


DROP TABLE IF EXISTS BlogPages;

CREATE TABLE BlogPages (
  bpa_bpaid                             VARCHAR(35) NOT NULL,
  bpa_blog                              VARCHAR(50),
  bpa_title                             VARCHAR(255),
  bpa_alias                             VARCHAR(100),
  bpa_body                              LONGTEXT,
  bpa_showlayout                        TINYINT(1) NOT NULL default '0',
  KEY(bpa_blog),
  KEY(bpa_alias),
  KEY(bpa_title)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;


DROP TABLE IF EXISTS BlogRoles;

CREATE TABLE BlogRoles (
  bro_broid                             VARCHAR(35) NOT NULL,
  bro_role                              VARCHAR(50),
  bro_description                       VARCHAR(255),
  PRIMARY KEY (bro_broid),
  KEY(bro_role)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS BlogSearchStats;

CREATE TABLE BlogSearchStats (
  bss_term                              VARCHAR(255),
  bss_searched                          DATETIME,
  bss_blog                              VARCHAR(50)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;


DROP TABLE IF EXISTS BlogSubscribers;

CREATE TABLE BlogSubscribers (
  bsu_email                             VARCHAR(50),
  bsu_token                             VARCHAR(35),
  bsu_blog                              VARCHAR(50),
  bsu_verified                          TINYINT(1),
  KEY(bsu_blog),
  KEY(bsu_verified),
  KEY(bsu_email),
  KEY(bsu_token)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;


DROP TABLE IF EXISTS BlogTextBlocks;

CREATE TABLE BlogTextBlocks (
  btb_btbid                             VARCHAR(35),
  btb_label                             VARCHAR(255),
  btb_body                              LONGTEXT,
  btb_blog                              VARCHAR(50),
  KEY(btb_blog),
  KEY(btb_label)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;


DROP TABLE IF EXISTS BlogUserRoles;

CREATE TABLE BlogUserRoles (
  bur_username                          VARCHAR(50),
  bur_broid                             VARCHAR(35),
  bur_blog                              VARCHAR(50),
  KEY(bur_blog),
  KEY(bur_username),
  KEY(bur_broid)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS BlogUsers;

CREATE TABLE BlogUsers (
  bus_username                          VARCHAR(50),
  bus_password                          VARCHAR(256),
  bus_salt                              VARCHAR(256),
  bus_name                              VARCHAR(50),
  bus_blog                              VARCHAR(255),
  KEY(bus_username),
  KEY(bus_blog)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

insert into BlogUsers(
  bus_username,bus_password,bus_salt,bus_name,bus_blog
) values (
  'admin','74FAE06F4B7BB31F16FA3CB4C873C88FB3669E413603CD103D714CC8C6B153188CEE84D3172F60027D96BAB4A79F275543865C80A927312D5CF00F7DD3F1753A','2XlAbs2fFEESboQCMue3N7yATpwT1QKAFNGIU0hZ35g=','Admin','Default'
);


INSERT INTO BlogRoles (bro_role,bro_broid,bro_description) VALUES  ('AddCategory','7F183B27-FEDE-0D6F-E2E9C35DBC7BFF19','The ability to create a new category when editing a blog entry.'),
 ('ManageCategories','7F197F53-CFF7-18C8-53D0C85FCC2CA3F9','The ability to manage blog categories.'),
 ('Admin','7F25A20B-EE6D-612D-24A7C0CEE6483EC2','A special role for the admin. Allows all functionality.'),
 ('ManageUsers','7F26DA6C-9F03-567F-ACFD34F62FB77199','The ability to manage blog users.'),
 ('ReleaseEntries','800CA7AA-0190-5329-D3C7753A59EA2589','The ability to both release a new entry and edit any released entry.');

INSERT INTO BlogUserRoles(bur_username,bur_broid,bur_blog) VALUES ('admin','7F25A20B-EE6D-612D-24A7C0CEE6483EC2','Default');


CREATE TABLE BlogPagesCategories  (
  bpc_bcaid                             VARCHAR(35) NOT NULL,
  bpc_bpaid                             VARCHAR(35) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ;
