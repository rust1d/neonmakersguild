DROP procedure IF EXISTS documentTags_replace;

delimiter ;;

CREATE PROCEDURE documentTags_replace(
  IN _docid  INT,
  IN _tagids VARCHAR(250)
)
BEGIN
  DELETE
    FROM documentTags
   WHERE dt_docid = _docid;

  CALL create_temp_table_id_list(_tagids);

  INSERT INTO documentTags (dt_tagid, dt_docid)
    SELECT tag_tagid, _docid
      FROM Tags
           INNER JOIN _id_list ON _il_id = tag_tagid;
END;;

delimiter ;
