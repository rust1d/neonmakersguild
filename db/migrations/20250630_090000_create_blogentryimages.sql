-- DROP TABLE IF EXISTS BlogEntryImages;

CREATE TABLE BlogEntryImages (
  bei_beiid                             INT(11) NOT NULL AUTO_INCREMENT,
  bei_benid                             INT(11) NOT NULL,
  bei_uiid                              INT(11) NOT NULL,
  bei_caption                           VARCHAR(2000),
  PRIMARY KEY (bei_beiid),
  KEY(bei_benid),
  KEY(bei_uiid)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
