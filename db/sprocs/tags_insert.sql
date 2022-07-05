DROP procedure IF EXISTS tags_insert;

delimiter ;;

CREATE PROCEDURE tags_insert(
  IN _blog     int(11),
  IN _tag      varchar(25)
)
BEGIN

  INSERT INTO tags (
    tag_blog, tag_tag
  ) VALUES (
    _blog, lcase(_tag)
  );

  CALL tags_get_by_ids(LAST_INSERT_ID());
END;;

delimiter ;
