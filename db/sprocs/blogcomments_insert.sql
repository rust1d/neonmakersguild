DROP procedure IF EXISTS blogcomments_insert;

delimiter ;;

CREATE PROCEDURE blogcomments_insert(
  IN _blog             int(11),
  IN _benid            int(11),
  IN _usid             int(11),
  IN _name             varchar(50),
  IN _email            varchar(50),
  IN _comment          text,
  IN _posted           datetime,
  IN _subscribe        tinyint(1),
  IN _website          varchar(255),
  IN _moderated        tinyint(1),
  IN _subscribeonly    tinyint(1),
  IN _kill             varchar(35)
)
BEGIN

  INSERT INTO blogcomments (
    bco_blog, bco_benid, ben_usid, bco_name, bco_email, bco_comment, bco_posted, bco_subscribe, bco_website, bco_moderated, bco_subscribeonly, bco_kill
  ) VALUES (
    _blog, _benid, _usid, _name, _email, _comment, _posted, _subscribe, _website, _moderated, _subscribeonly, _kill
  );

  CALL blogcomments_get_by_ids(LAST_INSERT_ID());
END;;

delimiter ;
