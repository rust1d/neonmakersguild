DROP procedure IF EXISTS blogcomments_update;

delimiter ;;

CREATE PROCEDURE blogcomments_update(
  IN _bcoid            int(11),
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
  UPDATE blogcomments
     SET bco_blog          = IFNULL(_blog,           bco_blog),
         bco_benid         = IFNULL(_benid,          bco_benid),
         ben_usid          = IFNULL(_usid,           ben_usid),
         bco_name          = IFNULL(_name,           bco_name),
         bco_email         = IFNULL(_email,          bco_email),
         bco_comment       = IFNULL(_comment,        bco_comment),
         bco_posted        = IFNULL(_posted,         bco_posted),
         bco_subscribe     = IFNULL(_subscribe,      bco_subscribe),
         bco_website       = IFNULL(_website,        bco_website),
         bco_moderated     = IFNULL(_moderated,      bco_moderated),
         bco_subscribeonly = IFNULL(_subscribeonly,  bco_subscribeonly),
         bco_kill          = IFNULL(_kill,           bco_kill)
   WHERE bco_bcoid = _bcoid;

  CALL blogcomments_get_by_ids(_bcoid);
END;;

delimiter ;
