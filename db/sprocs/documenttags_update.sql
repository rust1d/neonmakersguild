DROP procedure IF EXISTS documenttags_update;

delimiter ;;

CREATE PROCEDURE documenttags_update(
  IN _dtid    int(11),
  IN _docid   int(11),
  IN _tagid   int(11)
)
BEGIN
  UPDATE documenttags
     SET dt_docid = IFNULL(_docid, dt_docid),
         dt_tagid = IFNULL(_tagid, dt_tagid)
   WHERE dt_dtid = _dtid;

  CALL documenttags_get_by_ids(_dtid);
END;;

delimiter ;
