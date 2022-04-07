DROP procedure IF EXISTS blogcategories_insert;

delimiter ;;

CREATE PROCEDURE blogcategories_insert(
  IN _blog        int(11),
  IN _category    varchar(50),
  IN _alias       varchar(50)
)
BEGIN

  INSERT INTO blogcategories (
    bca_blog, bca_category, bca_alias
  ) VALUES (
    _blog, _category, _alias
  );

  CALL blogcategories_get_by_ids(LAST_INSERT_ID());
END;;

delimiter ;
