DROP procedure IF EXISTS documentcategories_update;

delimiter ;;

CREATE PROCEDURE documentcategories_update(
  IN _dcid    int(11),
  IN _docid   int(11),
  IN _bcaid   int(11)
)
BEGIN
  UPDATE documentcategories
     SET dc_docid = IFNULL(_docid, dc_docid),
         dc_bcaid = IFNULL(_bcaid, dc_bcaid)
   WHERE dc_dcid = _dcid;

  CALL documentcategories_get_by_ids(_dcid);
END;;

delimiter ;
