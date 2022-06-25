DROP procedure IF EXISTS tags_update;

delimiter ;;

CREATE PROCEDURE tags_update(
  IN _tagid    int(11),
  IN _blog     int(11),
  IN _tag      varchar(25)
)
BEGIN
  UPDATE tags
     SET tag_tag   = IFNULL(_tag, tag_tag)
   WHERE tag_tagid = _tagid
     AND tag_blog  = _blog;

  CALL tags_get_by_ids(_tagid);
END;;

delimiter ;
