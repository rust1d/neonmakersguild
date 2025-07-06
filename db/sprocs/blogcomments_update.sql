DROP procedure IF EXISTS blogcomments_update;

delimiter ;;

CREATE PROCEDURE blogcomments_update(
  IN _bcoid      int(11),
  IN _blog       int(11),
  IN _benid      int(11),
  IN _beiid      int(11),
  IN _usid       int(11),
  IN _comment    text,
  IN _history    text
)
BEGIN
  UPDATE blogcomments
     SET bco_blog    = IFNULL(_blog,     bco_blog),
         bco_benid   = IFNULL(_benid,    bco_benid),
         bco_beiid   = IFNULL(_beiid,    bco_beiid),
         bco_usid    = IFNULL(_usid,     bco_usid),
         bco_comment = IFNULL(_comment,  bco_comment),
         bco_history = IFNULL(_history,  bco_history),
         bco_dla     = CURRENT_TIMESTAMP
   WHERE bco_bcoid = _bcoid;

  CALL blogcomments_get_by_ids(_bcoid);
END;;

delimiter ;
