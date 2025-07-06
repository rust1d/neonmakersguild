DROP procedure IF EXISTS blogcomments_insert;

delimiter ;;

CREATE PROCEDURE blogcomments_insert(
  IN _blog       int(11),
  IN _benid      int(11),
  IN _beiid      int(11),
  IN _usid       int(11),
  IN _comment    text,
  IN _history    text
)
BEGIN
  INSERT INTO blogcomments (
    bco_blog, bco_benid, bco_beiid, bco_usid, bco_comment, bco_history, bco_added, bco_dla
  ) VALUES (
    _blog, _benid, _beiid, _usid, _comment, _history, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
  );

  CALL blogcomments_get_by_ids(LAST_INSERT_ID());
END;;

delimiter ;
