DROP TABLE IF EXISTS events;

CREATE TABLE events (
  ev_evid        INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  ev_usid        INT(11) NOT NULL,
  ev_google_id   VARCHAR(200),
  ev_summary     VARCHAR(200) NOT NULL,
  ev_location    VARCHAR(500),
  ev_description VARCHAR(2000),
  ev_allday      TINYINT(1) DEFAULT 0,
  ev_timezone    VARCHAR(50) DEFAULT 'America/New_York',
  ev_start       DATETIME NOT NULL,
  ev_end         DATETIME,
  ev_added       DATETIME DEFAULT CURRENT_TIMESTAMP,
  ev_dla         DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (ev_evid),
  KEY ev_usid (ev_usid) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
