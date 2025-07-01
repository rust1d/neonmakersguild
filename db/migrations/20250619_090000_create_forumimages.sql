-- DROP TABLE IF EXISTS forumImages;

CREATE TABLE forumImages (
  fi_fiid        INT(11) NOT NULL AUTO_INCREMENT,
  fi_foid        INT(11) NOT NULL,
  fi_ftid        INT(11) NOT NULL,
  fi_fmid        INT(11) NOT NULL,
  fi_usid        INT(11) NOT NULL,
  fi_width       INT(11),
  fi_height      INT(11),
  fi_size        INT(11),
  fi_filename    VARCHAR(100),
  fi_added       DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (fi_fiid),
  INDEX (fi_foid) USING BTREE,
  INDEX (fi_ftid) USING BTREE,
  INDEX (fi_fmid) USING BTREE,
  INDEX (fi_usid) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
