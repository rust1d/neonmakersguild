-- DROP TABLE IF EXISTS subscriptions;

-- users can subscribe to:
-- forum
-- forumthread
-- blog
-- blogpost

-- user settings
-- alert when someone replies to my posts

-- when posting
-- checkbox to alert when someone replies to this post
-- this will insert subscriptions row with table ie forumthread, blog post
-- if someone is subscribed to a post, show unsub button at top of thread

CREATE TABLE subscriptions (
  ss_ssid          INT(11) NOT NULL AUTO_INCREMENT,
  ss_usid          INT(11) NOT NULL,
  ss_fkey          INT(11) NOT NULL,
  ss_table         VARCHAR(20) NOT NULL,
  ss_added         DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (ss_ssid),
  UNIQUE INDEX (ss_usid, ss_fkey, ss_table),
  KEY (ss_fkey)
) ENGINE=InnoDB;

/* ALTER TABLE userProfile
  ADD COLUMN up_notify TINYINT(4) DEFAULT 0 AFTER up_country; */
