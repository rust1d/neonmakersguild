DROP procedure IF EXISTS blogcategories_search;

delimiter ;;

CREATE PROCEDURE blogcategories_search(
  IN _bcaid       int(11),
  IN _blog        int(11),
  IN _category    varchar(50),
  IN _alias       varchar(50)
)
BEGIN
  SELECT blogcategories.*, us_user AS bca_blogname,
         (SELECT COUNT(*) FROM blogentrycategories WHERE bec_bcaid=bca_bcaid) AS bca_entrycnt
    FROM blogcategories
         INNER JOIN users ON us_usid = bca_blog
   WHERE (_bcaid IS NULL OR bca_bcaid = _bcaid)
     AND (_blog IS NULL OR bca_blog = _blog)
     AND (_category IS NULL OR bca_category = _category)
     AND (_alias IS NULL OR bca_alias = _alias)
     ORDER BY bca_category;
END;;

delimiter ;
