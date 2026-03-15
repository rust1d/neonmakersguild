DROP TABLE IF EXISTS usernotifications;

CREATE TABLE usernotifications (
  un_unid      INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  un_usid      INT(11) NOT NULL,
  un_type      VARCHAR(25) NOT NULL,
  un_ref_id    INT(11),
  un_message   VARCHAR(500) NOT NULL,
  un_data      VARCHAR(2000),
  un_read      TINYINT(1) DEFAULT 0,
  un_added     DATETIME DEFAULT CURRENT_TIMESTAMP,
  un_dla       DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (un_unid),
  KEY un_usid (un_usid) USING BTREE,
  KEY un_usid_read (un_usid, un_read) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
