DROP procedure IF EXISTS tags_delete;

delimiter ;;

CREATE PROCEDURE tags_delete(
  IN _tagid integer
)
BEGIN
  DELETE
    FROM tags
   WHERE tag_tagid = _tagid;

  SELECT ROW_COUNT() AS delete_count;
END;;

delimiter ;
