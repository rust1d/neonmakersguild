DROP TABLE IF EXISTS blogCategories;

CREATE TABLE blogCategories (
  bca_bcaid varchar(35) NOT NULL,
  bca_name varchar(50) default NULL,
  bca_alias varchar(50) default NULL,
  bca_blog varchar(50) default NULL,
  PRIMARY KEY  (bca_bcaid),
  KEY (bca_alias),
  KEY (bca_name),
  KEY (bca_blog)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS blogComments;

CREATE TABLE blogComments (
  id varchar(35) NOT NULL,
  entryidfk varchar(35) default NULL,
  name varchar(50) default NULL,
  email varchar(50) default NULL,
  comment text,
  posted datetime default NULL,
  subscribe tinyint(1) default NULL,
  bco_website varchar(255) default NULL,
  bco_moderated tinyint(1) default NULL,
  bco_subscribeonly tinyint(1) default NULL,
  bco_kill varchar(35) default NULL,
  PRIMARY KEY  (id),
  KEY blogComments_entryid (entryidfk),
  KEY blogComments_posted (posted),
  KEY blogComments_bco_moderated (bco_moderated),
  KEY blogComments_email (email),
  KEY blogComments_name (name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS blogEntries;

CREATE TABLE blogEntries (
  id varchar(35) NOT NULL,
  title varchar(100) default NULL,
  body longtext,
  posted datetime default NULL,
  morebody longtext,
  alias varchar(100) default NULL,
  username varchar(50) default NULL,
  blog varchar(50) default NULL,
  allowcomments tinyint(1) default NULL,
  enclosure varchar(255) default NULL,
  filesize int(11) unsigned default NULL,
  mimetype varchar(255) default NULL,
  views int(11) unsigned default NULL,
  released tinyint(1) default NULL,
  mailed tinyint(1) default NULL,
  summary varchar(255) default NULL,
  subtitle varchar(100) default NULL,
  keywords varchar(100) default NULL,
  duration varchar(10) default NULL,
  PRIMARY KEY  (id),
  KEY blogEntries_blog (blog),
  KEY blogEntries_released (released),
  KEY blogEntries_posted (posted),
  KEY blogEntries_title (title),
  KEY blogEntries_username (username),
  KEY blogEntries_alias (alias)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS blogEntriesCategories;

CREATE TABLE blogEntriesCategories (
  bec_bcaid varchar(35) default NULL,
  entryidfk varchar(35) default NULL,
  KEY blogEntriesCategories_entryidfk (entryidfk,  bec_bcaid)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS blogEntriesRelated;

CREATE TABLE blogEntriesRelated (
  entryid varchar(35) default NULL,
  relatedid varchar(35) default NULL,
  KEY blogEntriesRelated_entryid (entryid),
  KEY blogEntriesRelated_relatedid (relatedid)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS blogPages;

CREATE TABLE blogPages (
  id varchar(35) NOT NULL,
  blog varchar(50) default NULL,
  title varchar(255) default NULL,
  alias varchar(100) default NULL,
  body longtext,
  showlayout tinyint(1) NOT NULL,
  KEY blogPages_blog (blog),
  KEY blogPages_alias (alias),
  KEY blogPages_title (title)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS blogRoles;

CREATE TABLE blogRoles (
  id varchar(35) NOT NULL,
  role varchar(50) default NULL,
  description varchar(255) default NULL,
  PRIMARY KEY  (id),
  KEY blogRoles_role (role)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS blogSearchStats;

CREATE TABLE blogSearchStats (
  searchterm varchar(255) default NULL,
  searched datetime default NULL,
  blog varchar(50) default NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS blogSubscribers;

CREATE TABLE blogSubscribers (
  email varchar(50) default NULL,
  token varchar(35) default NULL,
  blog varchar(50) default NULL,
  verified tinyint(1) default NULL,
  KEY blogSubscribers_blog (blog),
  KEY blogSubscribers_verified (verified),
  KEY blogSubscribers_email (email),
  KEY blogSubscribers_token (token)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS blogTextBlocks;

CREATE TABLE blogTextBlocks (
  id varchar(35) default NULL,
  label varchar(255) default NULL,
  body longtext,
  blog varchar(50) default NULL,
  KEY blogTextBlocks_blog (blog),
  KEY blogTextBlocks_label (label)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS blogUserRoles;

CREATE TABLE blogUserRoles (
  username varchar(50) default NULL,
  roleidfk varchar(35) default NULL,
  blog varchar(50) default NULL,
  KEY blogUserRoles_blog (blog),
  KEY blogUserRoles_username (username),
  KEY blogUserRoles_roleidfk (roleidfk)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS blogUsers;

CREATE TABLE blogUsers (
  username varchar(50) default NULL,
  password varchar(256) default NULL,
  salt varchar(256) default NULL,
  name varchar(50) default NULL,
  blog varchar(255) default NULL,
  KEY blogUsers_username (username),
  KEY blogUsers_blog (blog)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
