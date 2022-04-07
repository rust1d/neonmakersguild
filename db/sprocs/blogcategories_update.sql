DROP procedure IF EXISTS blogcategories_update;

delimiter ;;

CREATE PROCEDURE blogcategories_update(
  IN _bcaid       int(11),
  IN _blog        int(11),
  IN _category    varchar(50),
  IN _alias       varchar(50)
)
BEGIN
  UPDATE blogcategories
     SET bca_blog     = IFNULL(_blog,      bca_blog),
         bca_category = IFNULL(_category,  bca_category),
         bca_alias    = IFNULL(_alias,     bca_alias)
   WHERE bca_bcaid = _bcaid;

  CALL blogcategories_get_by_ids(_bcaid);
END;;

delimiter ;
