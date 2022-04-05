CREATE TABLE articles (
  ar_arid        INT(11) NOT NULL AUTO_INCREMENT,
  ar_acid        INT(11) DEFAULT NULL,
  ar_auid        INT(11) DEFAULT NULL,
  ar_title       VARCHAR(75) DEFAULT NULL,
  ar_desc        VARCHAR(2000) DEFAULT NULL,
  ar_body        TEXT,
  ar_tags        VARCHAR(100) DEFAULT NULL,
  ar_image       VARCHAR(100) DEFAULT NULL,
  ar_publication DATETIME DEFAULT NULL,
  ar_add         DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (ar_arid)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
