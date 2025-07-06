-- DROP TABLE IF EXISTS commentImages;

CREATE TABLE commentImages (
  ci_ciid        INT(11) NOT NULL AUTO_INCREMENT,
  ci_bcoid       INT(11) NOT NULL,
  ci_benid       INT(11) NOT NULL,
  ci_beiid       INT(11) NOT NULL,
  ci_usid        INT(11) NOT NULL,
  ci_width       INT(11),
  ci_height      INT(11),
  ci_size        INT(11),
  ci_filename    VARCHAR(100),
  ci_added       DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (ci_ciid),
  INDEX (ci_bcoid) USING BTREE,
  INDEX (ci_benid) USING BTREE,
  INDEX (ci_beiid) USING BTREE,
  INDEX (ci_usid) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
