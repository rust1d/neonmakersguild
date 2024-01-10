-- DROP TABLE IF EXISTS notes;

CREATE TABLE notes (
  no_noid     INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  no_usid     INT(11),
  no_note     VARCHAR(2000),
  no_poster   VARCHAR(50),
  no_added    DATETIME,
  no_dla      DATETIME,
  PRIMARY KEY (no_noid),
  KEY no_usid (no_usid) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
