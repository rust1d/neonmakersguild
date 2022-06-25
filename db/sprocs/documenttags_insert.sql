DROP procedure IF EXISTS documenttags_insert;

delimiter ;;

CREATE PROCEDURE documenttags_insert(
  IN _docid   int(11),
  IN _tagid   int(11)
)
BEGIN

  INSERT INTO documenttags (
    dt_docid, dt_tagid
  ) VALUES (
    _docid, _tagid
  );

  CALL documenttags_get_by_ids(LAST_INSERT_ID());
END;;

delimiter ;
