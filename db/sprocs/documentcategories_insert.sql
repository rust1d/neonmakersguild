DROP procedure IF EXISTS documentcategories_insert;

delimiter ;;

CREATE PROCEDURE documentcategories_insert(
  IN _docid   int(11),
  IN _bcaid   int(11)
)
BEGIN

  INSERT INTO documentcategories (
    dc_docid, dc_bcaid
  ) VALUES (
    _docid, _bcaid
  );

  CALL documentcategories_get_by_ids(LAST_INSERT_ID());
END;;

delimiter ;
